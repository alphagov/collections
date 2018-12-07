require 'test_helper'

describe BrexitTaxonPresenter do
  include TaxonHelpers

  let(:content_hash) { education_taxon }
  let(:content_item) { ContentItem.new(content_hash) }
  let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
  let(:presenter) { described_class.new(taxon) }

  describe '#finder_link' do
    it 'should return a link for the finder' do
      assert_equal( "/prepare-eu-exit-live-uk/education", presenter.finder_link)
    end
  end

  describe '#description' do
    it 'should return description for taxon' do
      assert_equal("Includes studying abroad and Erasmus+.", presenter.description)
    end
  end
end
