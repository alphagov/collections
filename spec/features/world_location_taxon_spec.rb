require "integration_spec_helper"

RSpec.feature "World location taxon page" do
  include SearchApiHelpers
  include TaxonHelpers

  let(:base_path) { "/world/usa" }
  let(:taxon) { WorldWideTaxon.find(base_path) }
  let(:child_taxon_base_path) { "/world/news-and-events-usa" }
  let(:child_taxon) { WorldWideTaxon.find(child_taxon_base_path) }
  let(:feed_url) { "#{Plek.new.website_root}/world/usa.atom" }
  let(:email_url) { Plek.new.website_root + "/email-signup?link=#{base_path}" }

  scenario "contains both the atom and email signup url if we are browsing a world location" do
    world_usa = world_usa_taxon(base_path:, phase: "live")
    world_usa_news_events = world_usa_news_events_taxon(base_path: child_taxon_base_path)

    stub_content_store_has_item(base_path, world_usa)
    stub_content_store_has_item(child_taxon_base_path, world_usa_news_events)
    stub_content_for_taxon(taxon.content_id, search_results) # For the "general information" taxon
    stub_most_popular_content_for_taxon(taxon.content_id, search_results, filter_content_store_document_type: nil)
    stub_content_for_taxon(child_taxon.content_id, search_results)

    visit base_path

    expect(page).to have_selector("a[href='#{email_url}']", text: "Get emails for this topic")
    expect(page).to have_selector("button", text: "Subscribe to feed")
    expect(page).to have_selector(".gem-c-subscription-links input[value='#{feed_url}']")
  end

  scenario "does not contain the feed selector if we are browsing a world location leaf page" do
    world_usa = world_usa_taxon(base_path:, phase: "live")
    world_usa.delete("links")

    stub_content_store_has_item(base_path, world_usa)
    stub_content_for_taxon(taxon.content_id, search_results)

    visit base_path

    expect(page).not_to have_selector("button", text: "Subscribe to feed")
    expect(page).not_to have_selector(".gem-c-subscription-links input[value='#{feed_url}']")
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
