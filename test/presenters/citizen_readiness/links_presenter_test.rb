require 'test_helper'

describe CitizenReadiness::LinksPresenter do
  include TaxonHelpers

  FEATURED_LINKS = [ { "base_path" => "/visit-europe-brexit"} ].freeze

  FEATURED_TAXONS = [
    { "title" => "Work", "base_path" => "/work", "content_id" => "work-taxon-id" },
    { "title" => "Environment", "base_path" => "/environment", "content_id" => "environment-taxon-id" },
    { "title" => "Business and industry", "base_path" => "/business-and-industry", "content_id" => "business-taxon-id" },
    { "title" => "Education", "base_path" => "/education", "content_id" => "education-taxon-id" }
  ].freeze

  ALL_FEATURED_LINKS = FEATURED_TAXONS + FEATURED_LINKS

  REJECTED_TAXONS = [{ "title" => "Government", "base_path" => "/government/all" }].freeze

  let(:presenter) { described_class.new }

  describe '#featured_links' do
    it 'should return the featured taxons presenters' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => FEATURED_TAXONS }))

      featured_links = presenter.featured_links

      assert_equal(ALL_FEATURED_LINKS.count, featured_links.count)

      featured_links.map do |featured_link|
        assert_includes(ALL_FEATURED_LINKS.map { |link| link.fetch('base_path') }, featured_link.base_path)
      end
    end
  end

  describe '#other_links' do
    it 'should not process featured taxons when featured taxons are included in the content item' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => FEATURED_TAXONS }))

      Services.rummager.stubs(:search).never

      presenter.other_links
    end

    it 'should not process rejected taxons when rejected taxons are included in the content item' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => REJECTED_TAXONS }))

      Services.rummager.stubs(:search).never

      presenter.other_links
    end

    it 'should return empty array when no other level one taxons have content tagged to Brexit' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => [FEATURED_TAXONS, REJECTED_TAXONS].flatten }))

      other_links = presenter.other_links

      assert_empty(other_links)
    end

    it 'should return other level one taxons tagged to Brexit when these exist' do
      OTHER_TAXONS = [
        { "title" => "Brexit guidance", "base_path" => "/brexit-guidance", "content_id" => "first-content-id" }
      ].freeze

      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => [FEATURED_TAXONS, REJECTED_TAXONS, OTHER_TAXONS].flatten }))

      Services.rummager.stubs(:search).returns(
        "results" => [],
        "total" => 34,
        "start" => 0,
        "facets" => {
          "part_of_taxonomy_tree" => {
            "options" => [
              {
                "value" => {
                  "slug" => "first-content-id"
                },
                "documents" => 12
              },
              {
                "value" => {
                  "slug" => "second-content-id"
                },
                "documents" => 10
              },
              {
                "value" => {
                  "slug" => "third-content-id"
                },
                "documents" => 5
              }
            ]
          }
        }
      )

      other_links = presenter.other_links

      assert_equal(OTHER_TAXONS.map { |taxon| taxon.fetch('base_path') }, other_links.map(&:base_path))
    end
  end
end
