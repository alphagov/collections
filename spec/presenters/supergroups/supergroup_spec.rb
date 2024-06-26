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
        text: "See more news and communications in this topic",
        url: "/search/news-and-communications?parent=%2Feducation%2Fskills&topic=taxon_id",
      }

      expect(expected_details).to eq(supergroup.finder_link(base_path, taxon_id))
    end
  end

  describe "#partial_template" do
    it "returns the path to the section view" do
      expect("taxons/sections/news_and_communications").to eq(supergroup.partial_template)
    end
  end
end
