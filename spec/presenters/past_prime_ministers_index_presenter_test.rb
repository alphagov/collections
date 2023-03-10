RSpec.describe PastPrimeMinistersIndexPresenter do
  include PrimeMinistersHelpers

  describe "prime_ministers_between" do
    let(:nineteenth_century_pm_one) { { name: "The Rt Honourable Mr A", start_dates: [1801, 1803] } }
    let(:nineteenth_century_pm_two) { { name: "The Rt Honourable Mrs B", start_dates: [1902, 1897] } }
    let(:twentieth_century_pm_one) { { name: "The Rt Honourable Mr C", start_dates: [1952] } }
    let(:twentieth_century_pm_two) { { name: "The Rt Honourable Mrs D", start_dates: [1983, 2005] } }
    let(:twenty_first_century_pm_one) { { name: "The Rt Honourable Mr E", start_dates: [2002, 2005] } }
    let(:twenty_first_century_pm_two) { { name: "The Rt Honourable Mrs F", start_dates: [2003] } }

    it "should return ordered prime ministers for a given time period selected by their earliest start date" do
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
        actual_pm_names = presenter.prime_minsters_between(date_range.first, date_range.second).keys
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
        service: ["A political party 1901 to 1902", "A political party 1905 to 1906"],
      }

      expect(presenter.formatted_data(pm_with_historical_account)).to eq expected_formatted_data
    end

    it "correctly formats data for a prime minister without a historical account" do
      expected_formatted_data = {
        href: nil,
        image_src:,
        image_alt_text: name,
        heading_text: name,
        service: ["1901 to 1902", "1905 to 1906"],
      }

      expect(presenter.formatted_data(pm_without_historical_account)).to eq expected_formatted_data
    end
  end
end
