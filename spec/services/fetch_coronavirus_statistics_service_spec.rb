RSpec.describe FetchCoronavirusStatisticsService do
  describe ".call" do
    it "returns a Statistics object" do
      body = {
        data: [
          {
            "date" => "2021-03-18",
            "cumulativeFirstDoseVaccinations" => nil,
            "cumulativeSecondDoseVaccinations" => nil,
            "hospitalAdmissions" => nil,
            "newPositiveTests" => 6303,
          },
          {
            "date" => "2021-03-17",
            "cumulativeFirstDoseVaccinations" => 25_735_472,
            "cumulativeSecondDoseVaccinations" => 20_735_472,
            "hospitalAdmissions" => nil,
            "newPositiveests" => 5758,
          },
          {
            "date" => "2021-03-16",
            "cumulativeFirstDoseVaccinations" => 25_273_226,
            "cumulativeSecondDoseVaccinations" => 20_273_226,
            "hospitalAdmissions" => nil,
            "newPositiveests" => 5294,
          },
          {
            "date" => "2021-03-15",
            "cumulativeFirstDoseVaccinations" => 24_839_906,
            "cumulativeSecondDoseVaccinations" => 19_839_906,
            "hospitalAdmissions" => nil,
            "newPositiveests" => 5089,
          },
          {
            "date" => "2021-03-14",
            "cumulativeFirstDoseVaccinations" => 24_453_221,
            "cumulativeSecondDoseVaccinations" => 19_453_221,
            "hospitalAdmissions" => 426,
            "newPositiveests" => 4618,
          },
          {
            "date" => "2021-03-13",
            "cumulativeFirstDoseVaccinations" => 24_196_211,
            "cumulativeSecondDoseVaccinations" => 19_196_211,
            "hospitalAdmissions" => 460,
            "newPositiveests" => 5534,
          },
        ],
      }

      stub_request(:get, /coronavirus.data.gov.uk/)
        .to_return(status: 200, body: body.to_json)

      statistics = described_class.call
      expect(statistics).to be_a(described_class::Statistics)
      expect(statistics).to have_attributes(
        cumulative_vaccinations_date: Date.new(2021, 3, 17),
        cumulative_first_dose_vaccinations: 25_735_472,
        cumulative_second_dose_vaccinations: 20_735_472,
        hospital_admissions: 426,
        hospital_admissions_date: Date.new(2021, 3, 14),
        new_positive_tests: 6303,
        new_positive_tests_date: Date.new(2021, 3, 18),
      )
    end

    context "when there is missing data" do
      it "returns nil for no data" do
        stub_request(:get, /coronavirus.data.gov.uk/)
          .to_return(status: 200, body: { data: [] }.to_json)

        expect(described_class.call).to be_nil
      end

      it "sets only the fields that have data" do
        body = { data: [{ "date" => "2021-03-18",
                          "cumulativeFirstDoseVaccinations" => nil,
                          "cumulativeSecondDoseVaccinations" => nil,
                          "hospitalAdmissions" => nil,
                          "newPositiveTests" => 6303 }] }

        stub_request(:get, /coronavirus.data.gov.uk/)
          .to_return(status: 200, body: body.to_json)

        expect(described_class.call).to have_attributes(
          cumulative_vaccinations_date: nil,
          cumulative_first_dose_vaccinations: nil,
          cumulative_second_dose_vaccinations: nil,
          hospital_admissions: nil,
          hospital_admissions_date: nil,
          new_positive_tests: 6303,
          new_positive_tests_date: Date.new(2021, 3, 18),
        )
      end

      it "sets only fields where all related fields have data" do
        body = { data: [{ "date" => "2021-03-18",
                          "cumulativeFirstDoseVaccinations" => 25_735_472,
                          "cumulativeSecondDoseVaccinations" => nil,
                          "hospitalAdmissions" => nil,
                          "newPositiveTests" => 6303 }] }

        stub_request(:get, /coronavirus.data.gov.uk/)
          .to_return(status: 200, body: body.to_json)

        expect(described_class.call).to_not include(:cumulative_vaccinations_date)
        expect(described_class.call).to_not include(:cumulative_first_dose_vaccinations)
        expect(described_class.call).to_not include(:cumulative_second_dose_vaccinations)
      end
    end

    context "when the request to load data fails" do
      it "notifies GovukError for a general error" do
        stub_request(:get, /coronavirus.data.gov.uk/).to_return(status: 500)
        expect(GovukError).to receive(:notify)

        described_class.call
      end

      it "doesn't notify GovukError when a timeout occurs" do
        stub_request(:get, /coronavirus.data.gov.uk/).to_timeout
        expect(GovukError).not_to receive(:notify)

        described_class.call
      end

      it "doesn't notify GovukError on 502 and 504 errors" do
        stub_request(:get, /coronavirus.data.gov.uk/)
          .to_return(status: 502)
          .then
          .to_return(status: 504)

        expect(GovukError).not_to receive(:notify)

        2.times { described_class.call }
      end
    end

    context "when the cache has stale data and the request to load new data fails" do
      it "returns Statistics with the stale data" do
        stale_stats = {
          cumulative_vaccinations_date: Date.new(2021, 3, 17),
          cumulative_first_dose_vaccinations: 25_735_472,
          cumulative_second_dose_vaccinations: 20_735_472,
          hospital_admissions: 426,
          hospital_admissions_date: Date.new(2021, 3, 14),
          new_positive_tests: 6303,
          new_positive_tests_date: Date.new(2021, 3, 18),
        }

        fresh_attributes = { expires_in: 30.minutes, race_condition_ttl: 5.minutes }

        allow(Rails.cache).to receive(:fetch)
                          .with(described_class::CACHE_KEY)
                          .and_return(stale_stats)

        allow(Rails.cache).to receive(:fetch)
                          .with(described_class::CACHE_KEY, fresh_attributes)
                          .and_raise("Failed to load fresh data")

        expect(described_class.call).to have_attributes(stale_stats)
        expect(Rails.cache).to have_received(:fetch)
                           .with(described_class::CACHE_KEY, fresh_attributes)
      end
    end

    context "when the cache is empty and the request to load data fails" do
      before do
        stub_request(:get, /coronavirus.data.gov.uk/).to_return(status: 500)
      end

      it "returns nil" do
        expect(described_class.call).to be_nil
      end
    end
  end
end
