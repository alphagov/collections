require "integration_spec_helper"

RSpec.feature "Topical Event pages" do
  include SearchApiHelpers
  let(:content_item) { fetch_fixture("topical_event") }
  let(:base_path) { content_item["base_path"] }

  before do
    stub_content_store_has_item(base_path, content_item)
    stub_search(body: { results: [] })
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

  context "afghanistan response topical event" do
    let(:base_path) { "/government/topical-events/afghanistan-uk-government-response" }
    let(:afghanistan_travel_advice_base_path) { "/foreign-travel-advice/afghanistan" }

    before do
      stub_content_store_has_item(base_path)
      stub_content_store_has_item(afghanistan_travel_advice_base_path)
    end

    it "includes travel advice for Afghanistan" do
      visit base_path
      expect(page).to have_link(titleize_base_path(afghanistan_travel_advice_base_path), href: afghanistan_travel_advice_base_path)
    end
  end

  context "documents list" do
    let(:related_publications) { { "Policy on Topicals" => "/foo/policy_paper", "PM attends summit on topical events" => "/foo/news_story" } }
    let(:related_consultations) { { "A consultation on Topicals" => "/foo/consultation_one", "Another consultation" => "/foo/consultation_two" } }
    let(:related_announcements) { { "An announcement on Topicals" => "/foo/announcement_one", "Another announcement" => "/foo/announcement_two" } }

    it "displays links to all related documents" do
      stub_search(body: search_api_response(related_announcements))
      stub_search(body: search_api_response(related_publications), params: { "filter_format" => "publication" })
      stub_search(body: search_api_response(related_consultations), params: { "filter_format" => "consultation" })

      visit base_path

      expect(page).to have_text("Documents")
      expect(page).to have_text("Publications")
      expect(page).to have_text("Consultations")
      expect(page).to have_text("Announcements")

      within("#publications") do
        related_publications.each { |title, link| expect(page).to have_link(title, href: link) }
        expect(page).to have_link("See all publications", href: "/search/all?topical_events%5B%5D=something-very-topical")
      end

      within("#consultations") do
        related_consultations.each { |title, link| expect(page).to have_link(title, href: link) }
        expect(page).to have_link("See all consultations", href: "/search/policy-papers-and-consultations?content_store_document_type%5B%5D=open_consultations&content_store_document_type%5B%5D=closed_consultations&topical_events%5B%5D=something-very-topical")
      end

      within("#announcements") do
        related_announcements.each { |title, link| expect(page).to have_link(title, href: link) }
        expect(page).to have_link("See all announcements", href: "/search/news-and-communications?topical_events%5B%5D=something-very-topical")
      end
    end

    it "doesn't display any document headers when there are no related documents" do
      visit base_path

      expect(page).not_to have_text("Publications")
      expect(page).not_to have_text("Announcements")
      expect(page).not_to have_text("Consultations")
      expect(page).not_to have_text("Documents")
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
      expect(page).to have_text(I18n.t("topical_events.headings.featured"))
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
      expect(page).to_not have_text(I18n.t("topical_events.headings.featured"))
    end
  end

  context "when requesting the atom feed" do
    let(:related_documents) { { "An announcement on Topicals" => "/foo/announcement_one", "Another announcement" => "/foo/announcement_two" } }

    before do
      stub_search(body: search_api_response(related_documents))
    end

    it "sets the page title" do
      visit "#{base_path}.atom"
      expect(page).to have_title("#{content_item['title']} - Activity on GOV.UK")
    end

    it "should include the correct entries" do
      visit "#{base_path}.atom"

      entries = Hash.from_xml(page.html).dig("feed", "entry")

      expect(entries.first).to include("title" => "some_display_type: An announcement on Topicals")
      expect(entries.first["link"]).to include("href" => "http://www.test.gov.uk/foo/announcement_one")

      expect(entries.second).to include("title" => "some_display_type: Another announcement")
      expect(entries.second["link"]).to include("href" => "http://www.test.gov.uk/foo/announcement_two")
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

  def search_api_response(titles_and_links_hash)
    results_array = titles_and_links_hash.to_a.map do |title, link|
      {
        'link': link,
        'title': title,
        'public_timestamp': "2016-10-07T22:18:32Z",
        'display_type': "some_display_type",
      }
    end
    { 'results': results_array }
  end
end
