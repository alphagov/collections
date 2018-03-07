require 'test_helper'

include RummagerHelpers
include TaxonHelpers

describe WorldWideTaxonPresenter do
  describe '#rendering_type' do
    it 'returns ACCORDION when the taxon has children, but no grandchildren' do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: true)

      assert_equal(
        WorldWideTaxonPresenter::ACCORDION,
        WorldWideTaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon with children and no grandchildren to be rendered as an accordion page"
      )
    end

    it 'returns LEAF when the taxon has children and no grandchildren' do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: false)

      assert_equal(
        WorldWideTaxonPresenter::LEAF,
        WorldWideTaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon without children and grandchildren to be rendered as a leaf page"
      )
    end
  end
end
