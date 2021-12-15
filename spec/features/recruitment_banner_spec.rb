require "integration_spec_helper"

RSpec.feature "Recruitment banner" do
  include SearchApiHelpers

  context "Mainstream browse pages" do
    scenario "browse page is where we want to display recruitment banner" do
      schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
      schema["base_path"] = "/browse/benefits/manage-your-benefit"
      stub_content_store_has_item(schema["base_path"], schema)
      search_api_has_documents_for_browse_page(schema["content_id"], %w[/browse/benefits/manage-your-benefit], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

      visit schema["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-intervention")
    end

    scenario "browse page is not where we want to display recruitment banner" do
      schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
      stub_content_store_has_item(schema["base_path"], schema)
      search_api_has_documents_for_browse_page(schema["content_id"], [schema["base_path"]], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

      visit schema["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to_not have_selector(".gem-c-intervention")
    end
  end

  context "Specialist topic pages" do
    it "renders the banner for a selected non-curated topic" do
      base = {
        content_id: "content-id-for-dealing-with-hmrc",
        base_path: "/topic/dealing-with-hmrc",
        title: "dealing-with-hmrc".humanize,
        description: "Dealing with HMRC: detailed information",
        format: "topic",
        public_updated_at: 10.days.ago.iso8601,
        details: {
          groups: [],
        },
      }

      stub_content_store_has_item("/topic/dealing-with-hmrc", base)
      stub_topic_organisations("dealing-with-hmrc", "content-id-for-hmrc-dealing")

      visit "/topic/dealing-with-hmrc"

      expect(page).to have_selector(".gem-c-intervention")
    end
  end

  it "doesn't render the banner for a non-curated topic" do
    base = {
      content_id: "content-id-for-nope",
      base_path: "/topic/nope",
      title: "nope".humanize,
      description: "Nah",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {
        groups: [],
      },
    }

    stub_content_store_has_item("/topic/nope", base)
    stub_topic_organisations("nope", "content-id-for-nope")

    visit "/topic/nope"

    expect(page).to_not have_selector(".gem-c-intervention")
  end

  it "renders a non-curated subtopic" do
    base = {
      content_id: "content-id-for-capital-gains-tax",
      base_path: "/topic/personal-tax/capital-gains-tax",
      title: "personal-tax/capital-gains-tax".humanize,
      description: "Dealing with HMRC: detailed information",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {
        groups: [],
      },
      links: {
        "parent" => [
          "title" => "Personal tax",
          "base_path" => "/topic/personal-tax",
        ],
      },
    }

    search_api_has_documents_for_subtopic(
      "content-id-for-capital-gains-tax",
      %w[
        tax-is-for-funding
        services
        for-the-people
      ],
      page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
    )

    stub_content_store_has_item("/topic/personal-tax/capital-gains-tax", base)
    stub_topic_organisations("personal-tax/capital-gains-tax", "content-id-for-capital-gains-tax")

    visit "/topic/personal-tax/capital-gains-tax"

    expect(page).to have_selector(".gem-c-intervention")
  end
end
