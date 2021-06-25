RSpec.describe CoronavirusLandingPagePresenter do
  include CoronavirusContentItemHelper
  it "provides getter methods for all component keys" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    %i[
      header_section
      announcements_label
      announcements
      see_all_announcements_link
      risk_level
      nhs_banner
      sections
      sections_heading
      additional_country_guidance
      topic_section
      statistics_section
      notifications
      page_header
      timeline
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

  describe "#show_timeline_nations?" do
    it "should return true if any timeline entry has national applicability" do
      presenter = described_class.new(coronavirus_content_item_with_timeline_national_applicability)

      expect(presenter.show_timeline_nations?).to be true
    end
  end

  describe "#timeline_for_nation" do
    it "only returns the entries for requested country" do
      presenter = described_class.new(coronavirus_content_item_with_timeline_national_applicability)

      expect(presenter.timeline_for_nation("wales").size).to eq(3)
      expect(presenter.timeline_for_nation("wales").first).to match(hash_including("heading" => "International travel"))
      expect(presenter.timeline_for_nation("wales").second).to match(hash_including("heading" => "In Wales"))
      expect(presenter.timeline_for_nation("wales").last).to match(hash_including("heading" => "In England and Wales"))
    end
  end
end
