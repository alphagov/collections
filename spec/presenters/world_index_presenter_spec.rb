RSpec.describe WorldIndexPresenter do
  let(:fixture) { GovukSchemas::Example.find("world_index", example_name: "world_index") }
  let(:content_item) { ContentItem.new(fixture) }
  let(:world_index) { WorldIndex.new(content_item) }
  let(:world_index_presenter) { described_class.new(world_index) }

  describe "#title" do
    subject { world_index_presenter.title }

    it "returns the title from the content item" do
      expect(subject).to eq("Help and services around the world")
    end
  end
end
