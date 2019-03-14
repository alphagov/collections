require 'test_helper'

describe BrexitTaxonPresenter do
  include TaxonHelpers

  let(:content_hash) { education_taxon }
  let(:content_item) { ContentItem.new(content_hash) }
  let(:presenter) { described_class.new(content_item, 2) }

  describe '#link' do
    it 'should return a link for the finder' do
      assert_equal("/prepare-eu-exit/education", presenter.link)
    end
  end

  describe '#description' do
    it 'should return description for taxon' do
      assert_equal("Includes studying abroad and Erasmus+", presenter.description)
    end
  end

  describe 'tracking' do
    it 'should contain tracking data' do
      assert_equal({ "track-category" => "navGridContentClicked", "track-action" => 2, "track-label" => "Education" },
        presenter.featured_data_attributes)
      assert_equal({ "track-category" => "sideNavTopics", "track-action" => "Education"},
        presenter.sidebar_data_attributes)
    end
  end
end
