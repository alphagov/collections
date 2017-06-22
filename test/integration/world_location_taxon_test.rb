require 'integration_test_helper'
require 'slimmer/test_helpers/govuk_components'

class WorldLocationTaxonTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include TaxonHelpers
  include Slimmer::TestHelpers::GovukComponents

  it 'contains both the atom and email signup url if we are browsing a world location' do
    @base_path = '/world/usa'

    world_usa = world_usa_taxon(base_path: @base_path)

    content_store_has_item(@base_path, world_usa)

    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results, filter_navigation_document_supertype: nil)

    visit @base_path
    govuk_feeds = page.find('.feeds')

    expected_atom_url = Plek.new.website_root + "/government/world/usa.atom"
    expected_url = Plek.new.website_root + "/government/email-signup/new?email_signup%5Bfeed%5D=#{expected_atom_url}"

    assert govuk_feeds.has_link?(
      href: expected_url
    )

    assert govuk_feeds.has_link?(
      href: expected_atom_url
    )
  end

  it 'does not contain the feed selector if we are not browsing a world location' do
    @base_path = '/education/student-finance'
    student_finance = student_finance_taxon(base_path: @base_path)

    content_store_has_item(@base_path, student_finance)

    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results, filter_navigation_document_supertype: nil)

    visit @base_path

    assert page.has_no_selector?('.feeds')
  end

  it "displays the 'Updates, news and events from the UK government in [country]' for world location news pages tagged to a taxon" do
    @base_path = '/world/usa'
    world_usa = world_usa_taxon(base_path: @base_path)

    content_store_has_item(@base_path, world_usa)

    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results_with_news)

    visit @base_path

    puts page.body
    assert page.has_content?("Updates, news and events from the UK government in USA")
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

  def search_results_with_news
    [
      {
        "title" => "News about USA",
        "description" => "",
        "base_path" => "/government/world/usa/news",
        "link" => "/government/world/usa/news"
      },
      {
        "title" => "British Embassy Washington ",
        "description" => "We develop and maintain relations between the UK and USA.",
        "base_path" => "/government/world/organisations/british-embassy-washington",
        "link" => "british-embassy-washington"
      },
    ]
  end
end
