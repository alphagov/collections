require 'integration_test_helper'

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
    content_store_has_item("/topic", {
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
      }
    })

    visit "/topic"

    assert page.has_content?("Oil and Gas")
  end

  it "renders a topic tag page and list its subtopics" do
    content_store_has_item("/topic/oil-and-gas", oil_and_gas_topic_item.merge({
      :links => {
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
      }
    }))

    visit "/topic/oil-and-gas"
    assert page.has_title?("Oil and gas - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
    end

    within ".topics ul" do
      within "li:nth-child(1)" do
        assert page.has_link?("Wells")
      end

      within "li:nth-child(2)" do
        assert page.has_link?("Fields")
      end

      within "li:nth-child(3)" do
        assert page.has_link?("Offshore")
      end
    end
  end

  it "renders a beta topic" do
    content_store_has_item("/topic/oil-and-gas", oil_and_gas_topic_item.merge({
      :details => {
        "beta" => true,
      }
    }))

    visit "/topic/oil-and-gas"

    assert page.has_content?("This page is in beta"), "has beta-label"
  end
end
