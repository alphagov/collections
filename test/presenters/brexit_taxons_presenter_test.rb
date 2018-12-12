require 'test_helper'

describe BrexitTaxonsPresenter do
  include TaxonHelpers

  FEATURED_TAXONS = [
    { "title" => "Going and being abroad", "base_path" => "/going-and-being-abroad", "content_id" => "going-taxon-id" },
    { "title" => "Work", "base_path" => "/work", "content_id" => "work-taxon-id" },
    { "title" => "Transport", "base_path" => "/transport", "content_id" => "transport-taxon-id" },
    { "title" => "Environment", "base_path" => "/environment", "content_id" => "environment-taxon-id" },
    { "title" => "Business and industry", "base_path" => "/business-and-industry", "content_id" => "business-taxon-id" },
    { "title" => "Education", "base_path" => "/education", "content_id" => "education-taxon-id" }
  ].freeze

  REJECTED_TAXONS = [{ "title" => "Government", "base_path" => "/government/all" }].freeze

  let(:presenter) { described_class.new }

  describe '#featured_taxons' do
    it 'should return the featured taxons presenters' do
      FEATURED_TAXONS.each do |taxon|
        ContentItem.stubs(:find!)
          .with(taxon.fetch('base_path'))
          .returns(ContentItem.new(generic_taxon(taxon.fetch('base_path'))))
      end

      featured_taxons = presenter.featured_taxons

      assert_equal(FEATURED_TAXONS.count, featured_taxons.count)

      featured_taxons.map do |featured_taxon|
        assert_includes(FEATURED_TAXONS.map { |taxon| taxon.fetch('base_path') }, featured_taxon.base_path)
      end
    end
  end

  describe '#other_taxons' do
    it 'should not process featured taxons when featured taxons are included in the content item' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => FEATURED_TAXONS }))

      Services.rummager.stubs(:search).never

      presenter.other_taxons
    end

    it 'should not process rejected taxons when rejected taxons are included in the content item' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => REJECTED_TAXONS }))

      Services.rummager.stubs(:search).never

      presenter.other_taxons
    end

    it 'should return empty array when no other level one taxons have content tagged to Brexit' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => [FEATURED_TAXONS, REJECTED_TAXONS].flatten }))

      other_taxons = presenter.other_taxons

      assert_empty(other_taxons)
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

      other_taxons = presenter.other_taxons

      assert_equal(OTHER_TAXONS.map { |taxon| taxon.fetch('base_path') }, other_taxons.map(&:base_path))
    end
  end
end
