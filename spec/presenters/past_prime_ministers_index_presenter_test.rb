RSpec.describe PastPrimeMinistersIndexPresenter do
  include PrimeMinistersHelpers

  describe "featured_profile_groups" do
    it "returns pms for each century" do
      pm_1 = api_data_for_person_without_historical_account("Person 1", "/person-1", [1801])
      pm_2 = api_data_for_person_without_historical_account("Person 2", "/person-2", [1901])
      pm_3 = api_data_for_person_without_historical_account("Person 3", "/person-3", [2001])

      presenter = PastPrimeMinistersIndexPresenter.new([pm_1, pm_2, pm_3])

      expected_names_per_century = {
        "21st_century" => ["Person 3"],
        "20th_century" => ["Person 2"],
        "18th_and_19th_centuries" => ["Person 1"],
      }

      actual_featured_profile_groups = presenter.featured_profile_groups

      expected_names_per_century.each do |century, expected_names|
        actual_names = actual_featured_profile_groups[century].map { |century_data| century_data[:heading_text] }
        expect(actual_names).to eq(expected_names)
      end
    end
  end

  describe "other_profile_groups" do
    it "an empty hash" do
      pm_1 = api_data_for_person_without_historical_account("Person 1", "/person-1", [1801])

      presenter = PastPrimeMinistersIndexPresenter.new([pm_1])

      expect(presenter.other_profile_groups).to eq({})
    end
  end

  describe "prime_ministers_between" do
    let(:nineteenth_century_pm_one) { { name: "The Rt Honourable Mrs A", start_dates: [1804, 1797] } }
    let(:nineteenth_century_pm_two) { { name: "The Rt Honourable Mr B", start_dates: [1810, 1812] } }
    let(:twentieth_century_pm_one) { { name: "The Rt Honourable Mrs C", start_dates: [1888, 1902] } }
    let(:twentieth_century_pm_two) { { name: "The Rt Honourable Mr D", start_dates: [1952] } }
    let(:twenty_first_century_pm_one) { { name: "The Rt Honourable Mr E", start_dates: [1983, 2002] } }
    let(:twenty_first_century_pm_two) { { name: "The Rt Honourable Mrs F", start_dates: [2003] } }

    it "should return ordered prime ministers for a given time period selected by their latest start date" do
      pms_with_historical_accounts = [nineteenth_century_pm_one, twentieth_century_pm_one, twenty_first_century_pm_one].map do |pm|
        name = pm[:name]
        slug = name.gsub(" ", "_")
        api_data_for_person_with_historical_account(name, slug, "/image_#{slug}", pm[:start_dates], "A political party")
      end

      pms_without_historical_accounts = [nineteenth_century_pm_two, twentieth_century_pm_two, twenty_first_century_pm_two].map do |pm|
        name = pm[:name]
        api_data_for_person_without_historical_account(name, name.gsub(" ", "_"), pm[:start_dates])
      end

      presenter = PastPrimeMinistersIndexPresenter.new(pms_without_historical_accounts + pms_with_historical_accounts)

      date_ranges_to_expected_pms = {
        [1801, 1900] => [nineteenth_century_pm_two, nineteenth_century_pm_one],
        [1901, 2000] => [twentieth_century_pm_two, twentieth_century_pm_one],
        [2001, 2024] => [twenty_first_century_pm_two, twenty_first_century_pm_one],
      }

      date_ranges_to_expected_pms.each do |date_range, expected_pms|
        actual_pm_names = presenter.prime_minsters_between(date_range.first, date_range.second).map { |pm| pm[:heading_text] }
        expected_pm_names = expected_pms.map { |pm| pm[:name] }
        expect(actual_pm_names).to eq expected_pm_names
      end
    end
  end

  describe "formatted_data" do
    let(:name) { "The RT Honourable Mr T" }
    let(:slug) { "mr-t" }
    let(:image_src) { "/image_of_#{slug}" }
    let(:start_years) { [1901, 1905] }
    let(:political_party) { "A political party" }
    let(:pm_with_historical_account) { api_data_for_person_with_historical_account(name, slug, image_src, start_years, political_party) }
    let(:pm_without_historical_account) { api_data_for_person_without_historical_account(name, image_src, start_years) }
    let(:presenter) { PastPrimeMinistersIndexPresenter.new([pm_with_historical_account, pm_without_historical_account]) }

    it "correctly formats data for a prime minister with a historical account" do
      expected_formatted_data = {
        href: "/government/history/past-prime-ministers/#{slug}",
        image_src:,
        image_alt_text: name,
        heading_text: name,
        service: ["A political party 1905 to 1906", "A political party 1901 to 1902"],
      }

      expect(presenter.formatted_data(pm_with_historical_account)).to eq expected_formatted_data
    end

    it "correctly formats data for a prime minister without a historical account" do
      expected_formatted_data = {
        href: nil,
        image_src:,
        image_alt_text: name,
        heading_text: name,
        service: ["1905 to 1906", "1901 to 1902"],
      }

      expect(presenter.formatted_data(pm_without_historical_account)).to eq expected_formatted_data
    end
  end
end
