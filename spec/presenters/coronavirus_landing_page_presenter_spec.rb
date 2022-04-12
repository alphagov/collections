RSpec.describe CoronavirusLandingPagePresenter do
  include CoronavirusContentItemHelper
  it "provides getter methods for all component keys" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    %i[
      header_section
      risk_level
      sections
      sections_heading
      additional_country_guidance
      notifications
      page_header
    ].each do |method|
      expect(presenter).to respond_to(method)
    end
  end

  it "build valid FAQ Schema" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    faq_schema = presenter.faq_schema(coronavirus_landing_page_content_item)
    expect("https://schema.org").to eq(faq_schema[:@context])
    expect("FAQPage").to eq(faq_schema[:@type])

    faq_schema[:mainEntity].each do |question|
      expect("Question").to eq(question[:@type])
      expect("Answer").to eq(question[:acceptedAnswer][:@type])
    end
  end

  it "returns topic_section links data" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    expect(presenter.topic_section[:links]).not_to be_empty
  end
end
