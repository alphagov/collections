require "integration_spec_helper"

RSpec.feature "World Location News pages" do
  let(:content_item) { fetch_fixture("world_location_news") }
  let(:base_path) { content_item["base_path"] }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  it "sets the page title" do
    visit base_path
    expect(page).to have_title("UK and Mock Country - GOV.UK")
  end

  it "sets the page meta description" do
    visit base_path
    expect(page).to have_selector("meta[name='description'][content='Find out about the relations between the UK and Mock Country']", visible: :hidden)
  end
end
