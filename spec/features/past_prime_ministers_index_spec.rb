require "integration_spec_helper"

RSpec.feature "Past Prime Mininsters page" do
  let(:content_item) { fetch_fixture("past_prime_ministers") }
  let(:base_path) { content_item["base_path"] }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  it "sets the page title" do
    visit base_path
    expect(page).to have_title(content_item[:title])
  end

  it "sets renders the title on the page" do
    visit base_path
    expect(page).to have_text(content_item[:title])
  end

  it "includes headers for each century" do
    visit base_path
    expect(page).to have_text("21st century")
    expect(page).to have_text("20th century")
    expect(page).to have_text("18th & 19th centuries")
  end
end
