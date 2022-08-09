require "integration_spec_helper"

RSpec.feature "World Location News pages" do
  let(:content_item) { fetch_fixture("world_location_news") }
  let(:base_path) { content_item["base_path"] }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  
end
