require 'test_helper'

describe TaxonPresenter do
  describe '#rendering_type' do
    it 'returns GRID when the taxon has grandchildren' do
      taxon = mock
      taxon.stubs(grandchildren?: true)

      assert_equal(
        TaxonPresenter::GRID,
        TaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon with grandchildren to be rendered as a grid page"
      )
    end

    it 'returns ACCORDION when the taxon has children, but no grandchildren' do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: true)

      assert_equal(
        TaxonPresenter::ACCORDION,
        TaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon with children and no grandchildren to be rendered as an accordion page"
      )
    end

    it 'returns LEAF when the taxon has children and no grandchildren' do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: false)

      assert_equal(
        TaxonPresenter::LEAF,
        TaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon without children and grandchildren to be rendered as a leaf page"
      )
    end
  end

  describe '#accordion_content' do
    it "calls the WorldTaxonomySorter class to sort accordion content for world related taxons" do
      taxon = mock
      taxon.stubs(grandchildren?: false,
                  children?: true,
                  world_related?: true,
                  child_taxons: %w(a b c),
                  tagged_content: [])

      WorldTaxonomySorter.expects(:call).returns(%w(c b a))
      TaxonPresenter.new(taxon).accordion_content
    end
  end
end
