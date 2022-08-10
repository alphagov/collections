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

  context "when there are featured documents" do
    it "includes the featured documents header" do
      visit base_path
      expect(page).to have_text(I18n.t("world_location_news.headings.featured"))
    end

    it "includes links to the featured documents" do
      visit base_path
      expect(page).to have_link("A document related to this location", href: "https://www.gov.uk/somewhere")
    end
  end

  context "when there are no featured documents" do
    before do
      stub_content_store_has_item(base_path, content_item_without_detail(content_item, "ordered_featured_documents"))
    end

    it "does not include the featured documents header" do
      visit base_path
      expect(page).to_not have_text(I18n.t("world_location_news.headings.featured"))
    end
  end

  context "when there is a mission statement" do
    it "includes the mission statement header" do
      visit base_path
      expect(page).to have_text(I18n.t("world_location_news.headings.mission"))
    end

    it "includes the mission statement" do
      visit base_path
      expect(page).to have_text("Our mission is to test world location news.")
    end
  end

  context "when the mission statement is empty" do
    before do
      content_item["details"]["mission_statement"] = ""
      stub_content_store_has_item(base_path, content_item)
    end

    it "does not include the mission statement header" do
      visit base_path
      expect(page).to_not have_text(I18n.t("world_location_news.headings.mission"))
    end
  end

  context "when there are featured links" do
    it "includes the featured links" do
      visit base_path
      expect(page).to have_link("A link to somewhere", href: "https://www.gov.uk/somewhere")
      expect(page).to have_link("A second link to somewhere", href: "https://www.gov.uk/somewhere2")
    end
  end

private

  def content_item_without_detail(content_item, key_to_remove)
    content_item["details"] = content_item["details"].except(key_to_remove)
    content_item
  end
end
