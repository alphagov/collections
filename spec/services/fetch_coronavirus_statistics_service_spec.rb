RSpec.describe FetchCoronavirusStatisticsService do
  include CoronavirusContentItemHelper

  describe ".call" do
    it "returns a Statistics object" do
      stub_coronavirus_statistics

      statistics = described_class.call
      expect(statistics).to be_a(described_class::Statistics)
      expect(statistics).to have_attributes(
        cumulative_vaccinations_date: Date.new(2021, 3, 17),
        cumulative_first_dose_vaccinations: 25_735_472,
        cumulative_second_dose_vaccinations: 20_735_472,
        percentage_first_vaccine: 86,
        percentage_second_vaccine: 54,
        hospital_admissions: 900,
        current_week_hospital_admissions_change_number: 749,
        current_week_hospital_admissions_change_percentage: 21.4,
        hospital_admissions_date: Date.new(2021, 3, 17),
        current_week_positive_tests: 37_861,
        current_week_positive_tests_change_number: 2_651,
        current_week_positive_tests_change_percentage: 7.5,
        new_positive_tests: 5758,
        new_positive_tests_date: Date.new(2021, 3, 17),
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
                          "cumulativeFirstDoseVaccinations" => 21_345_876,
                          "cumulativeSecondDoseVaccinations" => 20_357_898,
                          "percentageFirstVaccine" => 80,
                          "percentageSecondVaccine" => 70,
                          "hospitalAdmissions" => nil,
                          "newPositiveTests" => nil }] }

        stub_request(:get, /coronavirus.data.gov.uk/)
          .to_return(status: 200, body: body.to_json)

        expect(described_class.call).to have_attributes(
          cumulative_vaccinations_date: Date.new(2021, 3, 18),
          cumulative_first_dose_vaccinations: 21_345_876,
          cumulative_second_dose_vaccinations: 20_357_898,
          percentage_first_vaccine: 80,
          percentage_second_vaccine: 70,
          hospital_admissions: nil,
          current_week_hospital_admissions_change_number: nil,
          current_week_hospital_admissions_change_percentage: nil,
          hospital_admissions_date: nil,
          new_positive_tests: nil,
          current_week_positive_tests: nil,
          current_week_positive_tests_change_number: nil,
          current_week_positive_tests_change_percentage: nil,
          new_positive_tests_date: nil,
        )
      end

      it "sets only fields where all related fields have data" do
        body = { data: [{ "date" => "2021-03-18",
                          "cumulativeFirstDoseVaccinations" => 25_735_472,
                          "cumulativeSecondDoseVaccinations" => nil,
                          "percentageFirstVaccine" => nil,
                          "percentageSecondVaccine": nil,
                          "hospitalAdmissions" => 6303,
                          "newPositiveTests" => nil }] }

        stub_request(:get, /coronavirus.data.gov.uk/)
          .to_return(status: 200, body: body.to_json)

        expect(described_class.call).to be_nil
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
          percentage_first_vaccine: 86,
          percentage_second_vaccine: 54,
          hospital_admissions: 426,
          current_week_hospital_admissions_change_number: 500,
          current_week_hospital_admissions_change_percentage: 5,
          hospital_admissions_date: Date.new(2021, 3, 14),
          new_positive_tests: 6303,
          current_week_positive_tests: 40_345,
          current_week_positive_tests_change_number: 3_000,
          current_week_positive_tests_change_percentage: 10,
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
