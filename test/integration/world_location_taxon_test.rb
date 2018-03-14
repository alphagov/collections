require 'integration_test_helper'
require 'slimmer/test_helpers/govuk_components'

class WorldLocationTaxonTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include TaxonHelpers
  include Slimmer::TestHelpers::GovukComponents

  it 'contains both the atom and email signup url if we are browsing a world location' do
    @base_path = '/world/usa'
    @child_taxon_base_path = '/world/news-and-events-usa'

    world_usa = world_usa_taxon(base_path: @base_path, phase: 'live')
    world_usa_news_events = world_usa_news_events_taxon(base_path: @child_taxon_base_path)

    content_store_has_item(@base_path, world_usa)
    content_store_has_item(@child_taxon_base_path, world_usa_news_events)

    @taxon = WorldWideTaxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results) # For the "general information" taxon
    stub_content_for_taxon(@taxon.content_id, search_results, filter_navigation_document_supertype: nil)
    stub_most_popular_content_for_taxon(@taxon.content_id, search_results, filter_content_purpose_supergroup: nil)

    @child_taxon = WorldWideTaxon.find(@child_taxon_base_path)
    stub_content_for_taxon(@child_taxon.content_id, search_results, filter_navigation_document_supertype: nil)

    visit @base_path
    govuk_feeds = page.find('.feeds')

    expected_atom_url = Plek.new.website_root + "/world/usa.atom"
    expected_url = Plek.new.website_root + "/government/email-signup/new?email_signup%5Bfeed%5D=#{expected_atom_url}"

    assert govuk_feeds.has_link?(
      href: expected_url
    )

    assert govuk_feeds.has_link?(
      href: expected_atom_url
    )
  end

  it 'does not contain the feed selector if we are browsing a world location leaf page' do
    @base_path = '/world/usa'

    world_usa = world_usa_taxon(base_path: @base_path)
    world_usa.delete("links")

    content_store_has_item(@base_path, world_usa)

    @taxon = WorldWideTaxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results, filter_navigation_document_supertype: nil)

    visit @base_path

    assert page.has_no_selector?('.feeds')
  end

private

  def search_results
    [
      {
        'title' => 'Content item 1',
        'description' => 'Description of content item 1',
        'link' => 'content-item-1'
      },
      {
        'title' => 'Content item 2',
        'description' => 'Description of content item 2',
        'link' => 'content-item-2'
      },
    ]
  end
end
