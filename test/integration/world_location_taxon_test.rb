require "integration_test_helper"

class WorldLocationTaxonTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include TaxonHelpers

  it "contains both the atom and email signup url if we are browsing a world location" do
    @base_path = "/world/usa"
    @child_taxon_base_path = "/world/news-and-events-usa"

    world_usa = world_usa_taxon(base_path: @base_path, phase: "live")
    world_usa_news_events = world_usa_news_events_taxon(base_path: @child_taxon_base_path)

    stub_content_store_has_item(@base_path, world_usa)
    stub_content_store_has_item(@child_taxon_base_path, world_usa_news_events)

    @taxon = WorldWideTaxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results) # For the "general information" taxon
    stub_content_for_taxon(@taxon.content_id, search_results)
    stub_most_popular_content_for_taxon(@taxon.content_id, search_results, filter_content_store_document_type: nil)

    @child_taxon = WorldWideTaxon.find(@child_taxon_base_path)
    stub_content_for_taxon(@child_taxon.content_id, search_results)

    visit @base_path

    email_url = Plek.new.website_root + "/email-signup?link=#{@base_path}"
    feed_url = Plek.new.website_root + "/world/usa.atom"

    assert page.has_selector?("a[href='#{email_url}']", text: "Get emails for this topic")
    assert page.has_selector?("button", text: "Subscribe to feed")
    assert page.has_selector?(".gem-c-subscription-links input[value='#{feed_url}']")
  end

  it "does not contain the feed selector if we are browsing a world location leaf page" do
    @base_path = "/world/usa"

    world_usa = world_usa_taxon(base_path: @base_path)
    world_usa.delete("links")

    stub_content_store_has_item(@base_path, world_usa)

    @taxon = WorldWideTaxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results)

    visit @base_path

    feed_url = Plek.new.website_root + "/world/usa.atom"

    assert page.has_no_selector?("button", text: "Subscribe to feed")
    assert page.has_no_selector?(".gem-c-subscription-links input[value='#{feed_url}']")
  end

private

  def search_results
    [
      {
        "title" => "Content item 1",
        "description" => "Description of content item 1",
        "link" => "world-content-item-1",
      },
      {
        "title" => "Content item 2",
        "description" => "Description of content item 2",
        "link" => "world-content-item-2",
      },
    ]
  end
end
