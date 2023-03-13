require "integration_spec_helper"

RSpec.feature "Past Foreign Secretaries pages" do
  let(:base_path) { "/government/history/past-foreign-secretaries" }
  let(:content_item) do
    {
      base_path:,
      title: "Past Foreign Secretaries",

    }
  end

  before do
    stub_content_store_has_item(base_path, content_item)
    visit base_path
  end

  describe "index page" do
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
    end

    it "can render a past foreign secretary without a link in the correct section" do
      within("div#historical-people-21st-century") do
        expect(page).to have_text("Margaret Becket")
      end

      within("div#historical-people-20th-century") do
        expect(page).to have_text("Sir Geoffrey Howe, Lord Howe of Aberavon")
      end

      within("div#historical-people-19th-century") do
        expect(page).to have_text("Robert Cecil, Marquess of Salisbury")
      end

      within("div#historical-people-18th-century") do
        expect(page).to have_text("Thomas Robinson, Lord Grantham")
      end
    end

    it "can render a past foreign secretary wth a link in the correct section" do
      within("div#historical-people-selection-of-profiles") do
        expect(page).to have_link "Edward Frederick Lindley Wood, Viscount Halifax", href: "/government/history/past-foreign-secretaries/edward-wood"
      end

      within("div#historical-people-20th-century") do
        expect(page).to have_link "Sir Austen Chamberlain", href: "/government/history/past-foreign-secretaries/austen-chamberlain"
      end

      within("div#historical-people-19th-century") do
        expect(page).to have_link "Robert Cecil, Marquess of Salisbury", href: "/government/history/past-foreign-secretaries/robert-cecil"
      end
    end
  end

  describe "individual foreign secretary show page" do
    it "sets the page title" do
      visit "#{base_path}/austen-chamberlain"
      expect(page).to have_title("History of Sir Austen Chamberlain - GOV.UK")
    end

    it "sets renders the title on the page" do
      visit "#{base_path}/austen-chamberlain"
      expect(page).to have_text("Sir Austen Chamberlain")
    end
  end
end
