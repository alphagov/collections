RSpec.describe Supergroups::Supergroup do
  include SearchApiHelpers

  let(:taxon_id) { "12345" }
  let(:supergroup_name) { "news_and_communications" }
  let(:supergroup) { Supergroups::Supergroup.new(supergroup_name) }
  let(:base_path) { "/education/skills" }
  let(:taxon_id) { "taxon_id" }

  describe "#title" do
    it "returns human readable title" do
      expect("News and communications").to eq(supergroup.title)
    end
  end

  describe "#finder_link" do
    it "returns finder link details" do
      expected_details = {
        data: {
          module: "gem-track-click",
          track_action: "/education/skills",
          track_category: "SeeAllLinkClicked",
          track_label: "news_and_communications",
        },
        text: "See more news and communications in this topic",
        url: "/search/news-and-communications?parent=%2Feducation%2Fskills&topic=taxon_id",
      }

      expect(expected_details).to eq(supergroup.finder_link(base_path, taxon_id))
    end

    it "returns correct data" do
      finder_link_data = supergroup.finder_link(base_path, taxon_id)[:data]
      expect(finder_link_data[:track_category]).to eq("SeeAllLinkClicked")
      expect(finder_link_data[:track_action]).to eq(base_path)
      expect(finder_link_data[:track_label]).to eq("news_and_communications")
    end
  end

  describe "#partial_template" do
    it "returns the path to the section view" do
      expect("taxons/sections/news_and_communications").to eq(supergroup.partial_template)
    end
  end

  describe "#data_module_label" do
    it "returns the data tracking attribute name used by Google Analytics" do
      expect("newsAndCommunications").to eq(supergroup.data_module_label)
    end
  end
end
