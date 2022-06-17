require "integration_spec_helper"

RSpec.feature "Topical Event pages" do
  let(:content_item) { fetch_fixture("topical_event") }
  let(:base_path) { content_item["base_path"] }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  it "sets the page title" do
    visit base_path
    expect(page).to have_title("#{content_item['title']} - GOV.UK")
  end

  it "sets the page description" do
    visit base_path
    expect(page).to have_text(content_item["description"])
  end

  it "sets the page meta description" do
    visit base_path
    expect(page).to have_selector("meta[name='description'][content='#{content_item['description']}']", visible: :hidden)
  end

  it "includes the image and alt text" do
    visit base_path
    expect(page).to have_css("img[src='https://www.gov.uk/some-image.png'][alt='Text describing the image']")
  end

  it "sets the body text" do
    visit base_path
    expect(page).to have_text(content_item.dig("details", "body"))
  end

  context "when the event is current" do
    it "does not show the archived text" do
      Timecop.freeze("2016-04-18") do
        visit base_path
        expect(page).not_to have_text("Archived")
      end
    end
  end

  context "when the event is archived" do
    it "shows the archived text" do
      Timecop.freeze("2016-05-18") do
        visit base_path
        expect(page).to have_text("Archived")
      end
    end
  end

  it "includes a link to the about page" do
    visit base_path
    expect(page).to have_link(content_item.dig("details", "about_page_link_text"), href: "#{base_path}/about")
  end

  context "when there are social media links" do
    it "includes links to the social media accounts" do
      visit base_path
      expect(page).to have_link("Facebook", href: "https://www.facebook.com/a-topical-event")
      expect(page).to have_link("Twitter", href: "https://www.twitter.com/a-topical-event")
    end
  end

  context "when there are no social media links" do
    before do
      stub_content_store_has_item(base_path, content_item_without_detail(content_item, "social_media_links"))
    end

    it "does not include links to any social media platforms" do
      visit base_path
      expect(page).to_not have_text("Facebook")
      expect(page).to_not have_text("Twitter")
    end
  end

  context "when there are featured documents" do
    it "includes the featured documents header" do
      visit base_path
      expect(page).to have_text(I18n.t("topical_events.featured"))
    end

    it "includes links to the featured documents" do
      visit base_path
      expect(page).to have_link("A document related to this event", href: "https://www.gov.uk/somewhere")
    end
  end

  context "when there are no featured documents" do
    before do
      stub_content_store_has_item(base_path, content_item_without_detail(content_item, "ordered_featured_documents"))
    end

    it "does not include the featured documents header" do
      visit base_path
      expect(page).to_not have_text(I18n.t("topical_events.featured"))
    end
  end

private

  def fetch_fixture(filename)
    json = File.read(
      Rails.root.join("spec", "fixtures", "content_store", "#{filename}.json"),
    )
    JSON.parse(json)
  end

  def content_item_without_detail(content_item, key_to_remove)
    content_item["details"] = content_item["details"].except(key_to_remove)
    content_item
  end
end
