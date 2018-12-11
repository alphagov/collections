require 'test_helper'

describe BrexitTaxonsPresenter do
  include TaxonHelpers

  FEATURED_TAXONS = [
    { "title" => "Going and being abroad", "base_path" => "/going-and-being-abroad" },
    { "title" => "Work", "base_path" => "/work" },
    { "title" => "Transport", "base_path" => "/transport" },
    { "title" => "Environment", "base_path" => "/environment" },
    { "title" => "Business and industry", "base_path" => "/business-and-industry" },
    { "title" => "Education", "base_path" => "/education" }
  ].freeze

  GOV_TAXONS = [{ "title" => "Government", "base_path" => "/government/all" }].freeze

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
    it 'should return empty array when no other level one taxons have content tagged to Brexit' do
      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => [FEATURED_TAXONS, GOV_TAXONS].flatten }))

      Services.rummager.stubs(:search).returns("total" => 0)

      other_taxons = presenter.other_taxons

      assert_empty(other_taxons)
    end

    it 'should return other level one taxons tagged to Brexit when these exist' do
      OTHER_TAXONS = [
        { "title" => "Brexit guidance", "base_path" => "/brexit-guidance" }
      ].freeze

      ContentItem.stubs(:find!)
        .with('/')
        .returns(ContentItem.new("links" => { "level_one_taxons" => [FEATURED_TAXONS, GOV_TAXONS, OTHER_TAXONS].flatten }))

      Services.rummager.stubs(:search).returns("total" => 1)

      other_taxons = presenter.other_taxons

      assert_equal(OTHER_TAXONS.map { |taxon| taxon.fetch('base_path') }, other_taxons.map(&:base_path))
    end
  end
end
