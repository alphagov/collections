RSpec.describe WorldLocationNews do
  let(:api_data) { fetch_fixture("world_location_news") }
  let(:content_item) { ContentItem.new(api_data) }
  let(:base_path) { content_item.base_path }
  let(:world_location_news) { described_class.new(content_item) }
end
