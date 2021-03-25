require "integration_spec_helper"

RSpec.feature "Topic browsing" do
  def oil_and_gas_topic_item(params = {})
    base = {
      base_path: "/topic/oil-and-gas",
      title: "Oil and gas",
      description: "Guidance for the oil and gas industry",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {},
      links: {},
    }
    base.merge(params)
  end

  it "is possible to visit the topic index page" do
    stub_content_store_has_item(
      "/topic",
      base_path: "/topic",
      title: "Topics",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {},
      links: {
        children: [
          {
            title: "Oil and Gas",
            base_path: "/topic/oil-and-gas",
          },
        ],
      },
    )

    visit "/topic"

    expect(page).to have_content("Oil and Gas")

    expect(page).to have_selector(".gem-c-breadcrumbs")
  end

  it "renders a topic tag page and list its subtopics" do
    stub_content_store_has_item(
      "/topic/oil-and-gas",
      oil_and_gas_topic_item.merge(links: {
        "children" => [
          {
            "title" => "Wells",
            "base_path" => "/topic/oil-and-gas/wells",
          },
          {
            "title" => "Fields",
            "base_path" => "/topic/oil-and-gas/fields",
          },
          {
            "title" => "Offshore",
            "base_path" => "/topic/oil-and-gas/offshore",
          },
        ],
      }),
    )

    visit "/topic/oil-and-gas"
    expect(page).to have_title("Oil and gas: detailed information - GOV.UK")

    within "header.page-header" do
      expect(page).to have_content("Oil and gas")
    end

    within ".app-c-topic-list" do
      within "li:nth-child(1)" do
        expect(page).to have_link("Fields")
      end

      within "li:nth-child(2)" do
        expect(page).to have_link("Offshore")
      end

      within "li:nth-child(3)" do
        expect(page).to have_link("Wells")
      end
    end
  end

  it "tracks click events on topic pages" do
    stub_content_store_has_item(
      "/topic",
      base_path: "/topic",
      title: "Topics",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {},
      links: {
        children: [
          {
            title: "Oil and Gas",
            base_path: "/topic/oil-and-gas",
          },
        ],
      },
    )

    visit "/topic"

    expect(page).to have_selector('.topics-page[data-module="gem-track-click"]')

    topic_link = page.find("a", text: "Oil and Gas")

    expect("navTopicLinkClicked").to eq(topic_link["data-track-category"])

    expect("1").to eq(topic_link["data-track-action"])

    expect("/topic/oil-and-gas").to eq(topic_link["data-track-label"])

    expect(topic_link["data-track-options"]).to be_present

    data_options = JSON.parse(topic_link["data-track-options"])
    expect("1").to eq(data_options["dimension28"])

    expect("Oil and Gas").to eq(data_options["dimension29"])
  end

  it "tracks clicks events on subtopic pages" do
    stub_content_store_has_item(
      "/topic/oil-and-gas",
      oil_and_gas_topic_item.merge(links: {
        "children" => [
          {
            "title" => "Wells",
            "base_path" => "/topic/oil-and-gas/wells",
          },
        ],
      }),
    )

    visit "/topic/oil-and-gas"

    expect(page).to have_selector('.topics-page[data-module="gem-track-click"]')

    within ".app-c-topic-list" do
      within "li:nth-child(1)" do
        subtopic_link = page.find("a", text: "Wells")

        expect("navSubtopicLinkClicked").to eq(subtopic_link["data-track-category"])

        expect("1").to eq(subtopic_link["data-track-action"])

        expect("/topic/oil-and-gas/wells").to eq(subtopic_link["data-track-label"])

        expect(subtopic_link["data-track-options"]).to be_present

        data_options = JSON.parse(subtopic_link["data-track-options"])
        expect("1").to eq(data_options["dimension28"])
        expect("Wells").to eq(data_options["dimension29"])
      end
    end
  end
end
