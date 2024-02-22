RSpec.describe "topic_list component", type: :view do
  include ComponentTestHelper

  def component_name
    "topic_list"
  end

  let(:simple_item) do
    {
      path: "/path",
      text: "Text",
    }
  end

  let(:see_more_link) do
    {
      path: "/more",
      text: "More",
      data_attributes: { test: "test" },
    }
  end

  it "renders nothing without a list of items" do
    render_component({})
    expect(rendered).to be_empty
  end

  it "renders a list of links" do
    render_component(items: [simple_item])
    expect(rendered).to have_selector(%(.app-c-topic-list__link[href="#{simple_item[:path]}"]), text: simple_item[:text])
  end

  it "renders links with data attributes" do
    simple_item[:data_attributes] = { test: "test" }
    render_component(items: [simple_item])

    expect(rendered).to have_selector(".app-c-topic-list__link[data-test='test']")
  end

  it "sets GA4 data attributes correctly" do
    ga4_data = {
      index_section: 1,
      index_section_count: 1,
      section: "Simple item",
    }

    expected = {
      "event_name": "navigation",
      "type": "document list",
      "index_link": 1,
      "index_total": 1,
      "section": "Simple item",
      "index_section": 1,
      "index_section_count": 1,
    }.to_json

    render_component(items: [simple_item], ga4_data:)
    assert_select "ul[data-module=ga4-link-tracker]"
    assert_select "ul[data-ga4-track-links-only]"
    assert_select ".govuk-link" do |link|
      expect(link.attr("data-ga4-link").to_s).to eq expected
    end
  end

  it "does not set index_section and index_section_count if they aren't passed" do
    ga4_data = {
      section: "Simple item",
    }

    expected = {
      "event_name": "navigation",
      "type": "document list",
      "index_link": 1,
      "index_total": 1,
      "section": "Simple item",
    }.to_json

    render_component(items: [simple_item], ga4_data:)

    assert_select ".govuk-link" do |link|
      expect(link.attr("data-ga4-link").to_s).to eq expected
    end
  end

  it "correctly sets the indexes when a see more link is loaded" do
    ga4_data = {
      section: "Simple item",
    }

    render_component(items: [simple_item], see_more_link:, ga4_data:)

    assert_select "[data-ga4-link]" do |links|
      links.each_with_index do |link, index|
        expected = {
          "event_name": "navigation",
          "type": "document list",
          "index_link": index + 1,
          "index_total": 2,
          "section": "Simple item",
        }.to_json

        expect(link.attr("data-ga4-link").to_s).to eq expected
      end
    end
  end

  it "does not set GA4 data attributes if it doesn't receive GA4 data" do
    render_component(items: [simple_item])
    expect(rendered).not_to have_selector("[data-ga4-link]")
  end

  it "renders a see more link" do
    render_component(items: [simple_item], see_more_link:)
    expect(rendered).to have_selector(".app-c-topic-list__item a[href='/more'][data-test='test']", text: "More")
  end

  it "adds branding correctly" do
    render_component(items: [simple_item], see_more_link:, brand: "attorney-generals-office")
    expect(rendered).to have_selector(".app-c-topic-list.brand--attorney-generals-office")
    expect(rendered).to have_selector(".app-c-topic-list .app-c-topic-list__link.brand__color")
    expect(rendered).to have_selector(".brand__color", text: "More")
  end

  it "renders small version" do
    render_component(items: [simple_item], small: true)
    expect(rendered).to have_selector(".app-c-topic-list.app-c-topic-list--small")
  end

  it "renders without margin-bottom by default" do
    render_component(items: [simple_item])
    # Margin bottom should not be applied by default
    expect(rendered).not_to have_selector(".govuk-\\!-margin-bottom-6")
  end

  it "renders with margin-bottom" do
    render_component(items: [simple_item], margin_bottom: true)
    expect(rendered).to have_selector(".govuk-\\!-margin-bottom-6")
  end
end
