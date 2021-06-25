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

  describe "#timeline_nations_items" do
    let(:expected) do
      [
        {
          checked: true,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "England",
            },
          text: "England",
          value: "england",
        },
        {
          checked: false,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Northern Ireland",
            },
          text: "Northern Ireland",
          value: "northern_ireland",
        },
        {
          checked: false,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Scotland",
            },
          text: "Scotland",
          value: "scotland",
        },
        {
          checked: false,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Wales",
            },
          text: "Wales",
          value: "wales",
        },
      ]
    end

    it "sets england to selected by default" do
      presenter = described_class.new(coronavirus_landing_page_content_item)

      expect(presenter.timeline_nations_items).to eq(expected)
    end

    it "sets england to selected if selected country is not in the uk" do
      presenter = described_class.new(coronavirus_landing_page_content_item)

      expect(presenter.timeline_nations_items("foo")).to eq(expected)
    end

    it "sets selected county to selected if selected country is in the uk" do
      presenter = described_class.new(coronavirus_landing_page_content_item)

      expected = [
        {
          checked: false,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "England",
            },
          text: "England",
          value: "england",
        },
        {
          checked: false,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Northern Ireland",
            },
          text: "Northern Ireland",
          value: "northern_ireland",
        },
        {
          checked: false,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Scotland",
            },
          text: "Scotland",
          value: "scotland",
        },
        {
          checked: true,
          data_attributes:
            {
              module: "gem-track-click",
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Wales",
            },
          text: "Wales",
          value: "wales",
        },
      ]
      expect(presenter.timeline_nations_items("wales")).to eq(expected)
    end
  end

  describe "#show_timeline_nations?" do
    it "should return true if any timeline entry has national applicability" do
      presenter = described_class.new(coronavirus_content_item_with_timeline_national_applicability)

      expect(presenter.show_timeline_nations?).to be true
    end
  end
end
