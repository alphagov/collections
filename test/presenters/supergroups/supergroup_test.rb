require 'test_helper'

describe Supergroups::Supergroup do
  include RummagerHelpers

  let(:taxon_id) { '12345' }
  let(:supergroup_name) { 'supergroup_name' }
  let(:supergroup) { Supergroups::Supergroup.new(supergroup_name) }

  describe '#title' do
    it 'returns human readable title' do
      assert 'Supergroup name', supergroup.title
    end
  end

  describe '#finder_link' do
    it 'returns finder link details' do
      base_path = '/base/path'

      expected_details = {
        text: 'See all supergroup name',
        url: 'search/advanced?group=supergroup_name&topic=%2Fbase%2Fpath'
      }

      assert expected_details, supergroup.finder_link(base_path)
    end
  end

  describe '#partial_template' do
    it 'returns the path to the section view' do
      assert 'taxons/sections/supergroup_name', supergroup.partial_template
    end
  end
end
