require "integration_test_helper"

class TopicBrowsingTest < ActionDispatch::IntegrationTest
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

    assert page.has_content?("Oil and Gas")

    assert page.has_css?(".gem-c-breadcrumbs")
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
    assert page.has_title?("Oil and gas: detailed information - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
    end

    within ".app-c-topic-list" do
      within "li:nth-child(1)" do
        assert page.has_link?("Fields")
      end

      within "li:nth-child(2)" do
        assert page.has_link?("Offshore")
      end

      within "li:nth-child(3)" do
        assert page.has_link?("Wells")
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

    assert page.has_selector?('.topics-page[data-module="track-click"]')

    topic_link = page.find("a", text: "Oil and Gas")

    assert_equal(
      "navTopicLinkClicked",
      topic_link["data-track-category"],
      "Expected a tracking category to be set in the data attributes",
    )

    assert_equal(
      "1",
      topic_link["data-track-action"],
      "Expected the link position to be set in the data attributes",
    )

    assert_equal(
      "/topic/oil-and-gas",
      topic_link["data-track-label"],
      "Expected the topic base path to be set in the data attributes",
    )

    assert topic_link["data-track-options"].present?

    data_options = JSON.parse(topic_link["data-track-options"])
    assert_equal(
      "1",
      data_options["dimension28"],
      "Expected the total number of topics to be present in the tracking options",
    )

    assert_equal(
      "Oil and Gas",
      data_options["dimension29"],
      "Expected the topic title to be present in the tracking options",
    )
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

    assert page.has_selector?('.topics-page[data-module="track-click"]')

    within ".app-c-topic-list" do
      within "li:nth-child(1)" do
        subtopic_link = page.find("a", text: "Wells")

        assert_equal(
          "navSubtopicLinkClicked",
          subtopic_link["data-track-category"],
          "Expected a tracking category to be set in the data attributes",
        )

        assert_equal(
          "1",
          subtopic_link["data-track-action"],
          "Expected the link position to be set in the data attributes",
        )

        assert_equal(
          "/topic/oil-and-gas/wells",
          subtopic_link["data-track-label"],
          "Expected the subtopic base path to be set in the data attributes",
        )

        assert subtopic_link["data-track-options"].present?

        data_options = JSON.parse(subtopic_link["data-track-options"])
        assert_equal(
          "1",
          data_options["dimension28"],
          "Expected the total number of subtopics to be present in the tracking options",
        )

        assert_equal(
          "Wells",
          data_options["dimension29"],
          "Expected the subtopic title to be present in the tracking options",
        )
      end
    end
  end
end
