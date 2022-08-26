RSpec.describe CostOfLivingLandingPagePresenter do
  it "provides getter methods for all component keys defined in the YAML" do
    # To keep the yaml and presenter in sync. If it fails update COMPONENTS in the presenter
    cost_of_living_hardcoded_content = YAML.load_file(Rails.root.join("config/cost_of_living_landing_page/content_item.yml")).deep_symbolize_keys
    presenter = described_class.new(cost_of_living_hardcoded_content)

    expect(described_class::COMPONENTS).to match(cost_of_living_hardcoded_content.keys)
    cost_of_living_hardcoded_content.each_key do |key|
      expect(presenter).to respond_to(key)
    end
  end
end
