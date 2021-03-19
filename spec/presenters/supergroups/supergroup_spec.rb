require "test_helper"

describe Supergroups::Supergroup do
  include SearchApiHelpers

  let(:taxon_id) { "12345" }
  let(:supergroup_name) { "news_and_communications" }
  let(:supergroup) { Supergroups::Supergroup.new(supergroup_name) }
  let(:base_path) { "/education/skills" }
  let(:taxon_id) { "taxon_id" }

  describe "#title" do
    it "returns human readable title" do
      assert "Supergroup name", supergroup.title
    end
  end

  describe "#finder_link" do
    it "returns finder link details" do
      expected_details = "/news-and-communications?parent=%2Feducation%2Fskills&topic=taxon_id"

      assert expected_details, supergroup.finder_link(base_path, taxon_id)
    end

    it "returns correct data" do
      finder_link_data = supergroup.finder_link(base_path, taxon_id)[:data]
      assert_equal "SeeAllLinkClicked", finder_link_data[:track_category]
      assert_equal base_path, finder_link_data[:track_action]
      assert_equal "news_and_communications", finder_link_data[:track_label]
    end
  end

  describe "#partial_template" do
    it "returns the path to the section view" do
      assert "taxons/sections/news_and_communications", supergroup.partial_template
    end
  end

  describe "#data_module_label" do
    it "returns the data tracking attribute name used by Google Analytics" do
      assert "supergroupName", supergroup.data_module_label
    end
  end
end
