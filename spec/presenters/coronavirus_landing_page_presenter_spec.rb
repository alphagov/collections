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
      topic_section
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
      presenter = described_class.new(coronavirus_landing_page_content_item, "foo")

      expect(presenter.timeline_nations_items).to eq(expected)
    end

    it "sets selected county to selected if selected country is in the uk" do
      presenter = described_class.new(coronavirus_landing_page_content_item, "wales")

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
      expect(presenter.timeline_nations_items).to eq(expected)
    end
  end

  describe "#timelines_for_nation" do
    it "returns the timeline broken down by nation with country tags for each entry" do
      presenter = described_class.new(coronavirus_landing_page_content_item)

      expected = [
        [
          "england",
          [
            {
              "heading" => "18 September",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "If you live, work or travel in the North East, you need to [follow different covid rules](/guidance/north-east-of-england-local-restrictions)\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK wide</strong>",
            },
            {
              "heading" => "15 September",
              "national_applicability" => %w[england],
              "paragraph" => "If you live, work or visit Bolton, you need to [follow different covid rules](/guidance/bolton-local-restrictions)\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies to </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>England</strong>",
            },
            {
              "heading" => "10 July",
              "national_applicability" => %w[england wales],
              "paragraph" => "May the Force be with you.",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies to </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>England</strong> <span class='govuk-visually-hidden'>and</span> <strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Wales</strong>",
            },
          ],
        ],
        [
          "northern_ireland",
          [
            {
              "heading" => "18 September",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "If you live, work or travel in the North East, you need to [follow different covid rules](/guidance/north-east-of-england-local-restrictions)\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK wide</strong>",
            },
            {
              "heading" => "15 July",
              "national_applicability" => %w[northern_ireland],
              "paragraph" => "You can now socialise indoors in a group of up to 6 people from no more than 2 households, including for overnight stays. Up to 15 people from no more than 3 households can meet in a private garden. Shops, hairdressers and visitor attractions can reopen as well as indoor areas of pubs and restaurants. Read the [guidance on current restrictions on nidirect](https://www.nidirect.gov.uk/articles/coronavirus-covid-19-regulations-guidance-what-restrictions-mean-you). \r\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies to </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Northern Ireland</strong>",
            },
          ],
        ],
        [
          "scotland",
          [
            {
              "heading" => "18 September",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "If you live, work or travel in the North East, you need to [follow different covid rules](/guidance/north-east-of-england-local-restrictions)\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK wide</strong>",
            },
            {
              "heading" => "14 September",
              "national_applicability" => %w[scotland],
              "paragraph" => "People must not meet in groups larger than 6 in England. There are [exceptions to this 'rule of 6'](/government/publications/coronavirus-covid-19-meeting-with-others-safely-social-distancing/coronavirus-covid-19-meeting-with-others-safely-social-distancing#seeing-friends-and-family)\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies to </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Scotland</strong>",
            },
          ],
        ],
        [
          "wales",
          [
            {
              "heading" => "18 September",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "If you live, work or travel in the North East, you need to [follow different covid rules](/guidance/north-east-of-england-local-restrictions)\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK wide</strong>",
            },
            {
              "heading" => "24 July",
              "national_applicability" => %w[wales],
              "paragraph" => "[Face coverings are mandatory in shops](/government/publications/face-coverings-when-to-wear-one-and-how-to-make-your-own/face-coverings-when-to-wear-one-and-how-to-make-your-own)\n",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies to </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Wales</strong>",
            },
            {
              "heading" => "10 July",
              "national_applicability" => %w[england wales],
              "paragraph" => "May the Force be with you.",
              "tags" => "<span class='govuk-visually-hidden'>, this guidance applies to </span><strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>England</strong> <span class='govuk-visually-hidden'>and</span> <strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Wales</strong>",
            },
          ],
        ],
      ]

      expect(presenter.timelines_for_nation).to eq(expected)
    end
  end
end
