RSpec.describe PastPrimeMinistersIndex do
  include PrimeMinistersHelpers

  let(:pms_with_historical_accounts) do
    ["The Rt Hon John Smith",
     "The Rt Hon Bobby B",
     "The Rt Hon Timmy T",
     "The Rt Hon Jimmy J",
     "The Rt Hon Reginald R"]
  end
  let(:pms_without_historical_accounts) { ["The Rt Hon No Biography MP", "The Rt Hon Older No Biography MP"] }

  before do
    historic_accounts_data = pms_with_historical_accounts.map { |name| api_data_for_person_with_historical_account(name, "/slug", "/image", [1900], "Labour") }
    other_pm_data = pms_without_historical_accounts.map { |name| api_data_for_person_without_historical_account(name, "/image", [1900]) }
    @api_data = past_pms_content_item(historic_accounts_data, other_pm_data)
  end

  describe "all_prime_ministers" do
    it "extracts all prime ministers (those with and without historical accounts) from the content item" do
      past_pms_index = described_class.new(ContentItem.new(@api_data))
      expected_names = pms_with_historical_accounts + pms_without_historical_accounts
      expect(past_pms_index.all_prime_ministers.map { |past_pm| past_pm["title"] }).to eq(expected_names)
    end
  end
end
