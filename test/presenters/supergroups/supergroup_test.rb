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

      expected_details = 'search/advanced?group=supergroup_name&topic=%2Fbase%2Fpath'

      assert expected_details, supergroup.finder_link(base_path)
    end

    it 'returns correct data' do
      base_path = '/base/path'
      finder_link_data = supergroup.finder_link(base_path)[:data]
      assert_equal "SeeAllLinkClicked", finder_link_data[:track_category]
      assert_equal base_path, finder_link_data[:track_action]
      assert_equal "supergroup_name", finder_link_data[:track_label]
    end
  end

  describe '#partial_template' do
    it 'returns the path to the section view' do
      assert 'taxons/sections/supergroup_name', supergroup.partial_template
    end
  end

  describe '#data_module_label' do
    it 'returns the data tracking attribute name used by Google Analytics' do
      assert 'supergroupName', supergroup.data_module_label
    end
  end
end
