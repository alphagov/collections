require "integration_spec_helper"

RSpec.feature "World Location News pages" do
  include SearchApiHelpers
  let(:content_item) { fetch_fixture("world_location_news") }
  let(:base_path) { content_item["base_path"] }

  before do
    stub_content_store_has_item(base_path, content_item)
    stub_search(body: { results: [] })
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

  context "when there are translations" do
    it "includes a link to the other languages only" do
      visit base_path

      expect(page).to have_link("Cymraeg", href: "/world/somewhere.cy")

      expect(page).to have_text("English")
      expect(page).not_to have_link("English", href: "/world/somewhere")
    end
  end

  context "when there are no translations" do
    before do
      content_item["links"]["available_translations"] = [
        {
          "locale": "en",
          "base_path": "/world/somewhere",
        },
      ]
      stub_content_store_has_item(base_path, content_item)
    end

    it "includes does not include the translation navigation" do
      visit base_path
      expect(page).not_to have_text("English")
    end
  end

  context "latest documents" do
    let(:latest_documents) { { "Some document" => "/foo/latest_one", "Another document" => "/foo/latest_two" } }

    it "displays the latest documents" do
      stub_search(body: search_api_response(latest_documents))

      visit base_path

      expect(page).to have_text("Latest")

      within("#latest") do
        latest_documents.each { |title, link| expect(page).to have_link(title, href: link) }
        expect(page).to have_link("See all", href: "/search/all?order=updated-newest&world_locations%5B%5D=mock-country")
      end
    end

    it "displays a message when there are no documents yet" do
      stub_search(body: search_api_response({}))

      visit base_path

      expect(page).to have_text("Latest")

      within("#latest") do
        expect(page).to have_text("There are no updates yet.")
      end
    end

    it "does not include the latest section when the locale is not English" do
      I18n.with_locale(:cy) do
        visit base_path
        expect(page).not_to have_text("Y diweddaraf")
      end
    end
  end

  context "documents list" do
    let(:related_announcements) { { "An announcement on World Locations" => "/foo/announcement_one", "Another announcement" => "/foo/announcement_two" } }
    let(:related_publications) { { "Policy on World Locations" => "/foo/policy_paper", "PM attends summit on world locations" => "/foo/news_story" } }
    let(:related_statistics) { { "Some statistic" => "/foo/statistic_one", "An interesting statistic" => "/foo/statistic_two" } }

    it "displays links to all related documents" do
      stub_search(body: search_api_response(related_announcements), params: { "filter_content_purpose_supergroup" => "news_and_communications" })
      stub_search(body: search_api_response(related_publications), params: { "filter_content_purpose_supergroup" => %w[guidance_and_regulation policy_and_engagement transparency] })
      stub_search(body: search_api_response(related_statistics), params: { "filter_content_purpose_subgroup" => "statistics" })

      visit base_path

      expect(page).to have_text("Documents")
      expect(page).to have_text("Our announcements")
      expect(page).to have_text("Our publications")
      expect(page).to have_text("Our statistics")

      within("#our-announcements") do
        related_announcements.each { |title, link| expect(page).to have_link(title, href: link) }
        expect(page).to have_link("See all our announcements", href: "/search/news-and-communications?world_locations%5B%5D=mock-country")
      end

      within("#our-publications") do
        related_publications.each { |title, link| expect(page).to have_link(title, href: link) }
        expect(page).to have_link("See all our publications", href: "/search/all?content_purpose_supergroup%5B%5D=guidance_and_regulation&content_purpose_supergroup%5B%5D=policy_and_engagement&content_purpose_supergroup%5B%5D=transparency&order=updated-newest&world_locations%5B%5D=mock-country")
      end

      within("#our-statistics") do
        related_statistics.each { |title, link| expect(page).to have_link(title, href: link) }
        expect(page).to have_link("See all our statistics", href: "/search/research-and-statistics?world_locations%5B%5D=mock-country")
      end
    end

    it "doesn't display any document headers when there are no related documents" do
      visit base_path

      expect(page).not_to have_text("Documents")
      expect(page).not_to have_text("Our announcements")
      expect(page).not_to have_text("Our publications")
      expect(page).not_to have_text("Our statistics")
    end
  end

private

  def content_item_without_detail(content_item, key_to_remove)
    content_item["details"] = content_item["details"].except(key_to_remove)
    content_item
  end
end
