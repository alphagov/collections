require 'integration_test_helper'

class TopicBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers

  def set_up_valid_topic_page
    subtopics = [
      { slug: "oil-and-gas/wells", title: "Wells", description: "Wells, wells, wells." },
      { slug: "oil-and-gas/fields", title: "Fields", description: "Fields, fields, fields." },
      { slug: "oil-and-gas/offshore", title: "Offshore", description: "Information about offshore oil and gas." },
    ]

    content_api_has_tag("specialist_sector", { slug: "oil-and-gas", title: "Oil and gas", description: "Guidance for the oil and gas industry" })
    content_api_has_sorted_child_tags("specialist_sector", "oil-and-gas", "alphabetical", subtopics)
  end

  it "renders a topic tag page and list its subtopics" do
    set_up_valid_topic_page
    content_store_has_item('/topic/oil-and-gas', content_schema_example(:topic, :topic))

    visit "/topic/oil-and-gas"
    assert page.has_title?("Oil and gas - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
    end

    within ".category-description" do
      assert page.has_content?("Guidance for the oil and gas industry")
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
    set_up_valid_topic_page

    content_store_has_item('/topic/oil-and-gas',
      content_schema_example(:topic, :topic).merge(details: { beta: true }))

    visit "/topic/oil-and-gas"

    assert page.has_content?("This page is in beta"), "has beta-label"
  end
end
