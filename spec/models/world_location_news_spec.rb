RSpec.describe WorldLocationNews do
  let(:api_data) { fetch_fixture("world_location_news") }
  let(:content_item) { ContentItem.new(api_data) }
  let(:base_path) { content_item.base_path }
  let(:world_location_news) { described_class.new(content_item) }

  it "should have a title" do
    expect(world_location_news.title).to eq("UK and Mock Country")
  end

  it "should have a description" do
    expect(world_location_news.description).to eq("Find out about the relations between the UK and Mock Country")
  end
end
