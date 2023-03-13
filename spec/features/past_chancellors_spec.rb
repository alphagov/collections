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
    visit base_path
  end

  it "sets the page title" do
    expect(page).to have_title("#{content_item[:title]} - GOV.UK")
  end

  it "sets renders the title on the page" do
    expect(page).to have_text(content_item[:title])
  end

  it "includes headers for each century" do
    expect(page).to have_text("21st century")
    expect(page).to have_text("20th century")
    expect(page).to have_text("19th century")
    expect(page).to have_text("18th century")
    expect(page).to have_text("16th & 17th centuries")
  end

  it "renders past foreign secretaries in the relevant section" do
    within("div#historical-people-21st-century") do
      expect(page).to have_text("Kwasi Kwarteng")
    end

    within("div#historical-people-20th-century") do
      expect(page).to have_text("Kenneth Clarke")
    end

    within("div#historical-people-19th-century") do
      expect(page).to have_text("Sir Michael Hicks")
    end

    within("div#historical-people-18th-century") do
      expect(page).to have_text("Lord John Cavendish")
    end

    within('div#historical-people-16th-\&-17th-centuries') do
      expect(page).to have_text("Charles Montagu")
    end
  end
end
