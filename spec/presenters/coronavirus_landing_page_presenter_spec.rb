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
      presenter = described_class.new(coronavirus_content_item_with_timeline_national_applicability)

      expected = [
        [
          "england",
          [
            {
              "heading" => "International travel",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "You should not travel to red or amber list countries or territories.\r\n[Check what you need to do to travel internationally](https://www.gov.uk/travel-abroad).\r\n",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK Wide</strong>",
            },
            {
              "heading" => "In England",
              "national_applicability" => %w[england],
              "paragraph" => "From 21 June, there’s a 4-week pause at Step 3 of the roadmap. After 2 weeks, the government will review the data to see if the risks have reduced. It's expected that England will move to Step 4 on 19 July.\r\n\r\nStep 3 restrictions remain in place - follow the [guidance on what you can and cannot do](/guidance/covid-19-coronavirus-restrictions-what-you-can-and-cannot-do). \r\n\r\nThe Delta COVID-19 variant is spreading in England. [See where it's spreading fastest and find out what you should do](/guidance/covid-19-coronavirus-restrictions-what-you-can-and-cannot-do).\r\n",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>England</strong>",
            },
            {
              "heading" => "In England and Wales",
              "national_applicability" => %w[england wales],
              "paragraph" => "May the Force be with you.",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>England</strong> <strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Wales</strong>",
            },
          ],
        ],
        [
          "northern_ireland",
          [
            {
              "heading" => "International travel",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "You should not travel to red or amber list countries or territories.\r\n[Check what you need to do to travel internationally](https://www.gov.uk/travel-abroad).\r\n",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK Wide</strong>",
            },
            {
              "heading" => "In Northern Ireland",
              "national_applicability" => %w[northern_ireland],
              "paragraph" => "You can now socialise indoors in a group of up to 6 people from no more than 2 households, including for overnight stays. Up to 15 people from no more than 3 households can meet in a private garden. Shops, hairdressers and visitor attractions can reopen as well as indoor areas of pubs and restaurants. Read the [guidance on current restrictions on nidirect](https://www.nidirect.gov.uk/articles/coronavirus-covid-19-regulations-guidance-what-restrictions-mean-you). \r\n",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Northern Ireland</strong>",
            },
          ],
        ],
        [
          "scotland",
          [
            {
              "heading" => "International travel",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "You should not travel to red or amber list countries or territories.\r\n[Check what you need to do to travel internationally](https://www.gov.uk/travel-abroad).\r\n",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK Wide</strong>",
            },
            {
              "heading" => "In Scotland",
              "national_applicability" => %w[scotland],
              "paragraph" => "From 5 June, many areas are changing COVID-19 protection levels. Find out [your area's level in Scotland on GOV.SCOT](https://www.gov.scot/publications/coronavirus-covid-19-protection-levels/).",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Scotland</strong>",
            },
          ],
        ],
        [
          "wales",
          [
            {
              "heading" => "International travel",
              "national_applicability" => %w[england northern_ireland scotland wales],
              "paragraph" => "You should not travel to red or amber list countries or territories.\r\n[Check what you need to do to travel internationally](https://www.gov.uk/travel-abroad).\r\n",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK Wide</strong>",
            },
            {
              "heading" => "In Wales",
              "national_applicability" => %w[wales],
              "paragraph" => "From 7 June, you can choose 2 other households to meet indoors, becoming an extended household. Up to 30 people can meet outside, including in gardens and pubs. [Read the rules for Wales on GOV.WALES](https://gov.wales/current-restrictions).",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Wales</strong>",
            },
            {
              "heading" => "In England and Wales",
              "national_applicability" => %w[england wales],
              "paragraph" => "May the Force be with you.",
              "tags" => "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>England</strong> <strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>Wales</strong>",
            },
          ],
        ],
      ]

      expect(presenter.timelines_for_nation).to eq(expected)
    end
  end
end
