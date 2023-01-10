require "integration_spec_helper"

RSpec.feature "Past Chancellors pages" do
  let(:base_path) { "/government/history/past-chancellors" }
  let(:content_item) do
    {
      base_path:,
      title: "Past Chancellors of the Exchequer",
    }
  end

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  it "sets the page title" do
    visit base_path
    expect(page).to have_title("#{content_item[:title]} - GOV.UK")
  end

  it "sets renders the title on the page" do
    visit base_path
    expect(page).to have_text(content_item[:title])
  end

  it "includes headers for each century" do
    visit base_path
    expect(page).to have_text("21st century")
    expect(page).to have_text("20th century")
    expect(page).to have_text("19th century")
    expect(page).to have_text("18th century")
    expect(page).to have_text("16th & 17th centuries")
  end
end
