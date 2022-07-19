require "integration_spec_helper"

RSpec.feature "Mainstream browsing" do
  include SearchApiHelpers

  scenario "that we can handle all examples" do
    # Shuffle the examples to ensure tests don't become order dependent
    schemas = GovukSchemas::Example.find_all("mainstream_browse_page").shuffle

    schemas.each do |content_item|
      stub_content_store_has_item(content_item["base_path"], content_item)

      search_api_has_documents_for_browse_page(
        content_item["content_id"],
        %w[
          employee-tax-codes
          get-paye-forms-p45-p60
          pay-paye-penalty
          pay-paye-tax
          pay-psa
          payroll-annual-reporting
        ],
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )

      visit content_item["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-breadcrumbs")
    end
  end

  context "level two specialist topic content exists for a level one browse page" do
    let(:level_one_browse_url) { "/browse/one" }
    let(:level_two_topic_url) { "/topic/second/level" }
    let(:test_yaml) do
      { "mappings" =>
        [
          {
            "browse_path" => level_one_browse_url,
            "topic_path" => level_two_topic_url,
          },
        ] }
    end

    let(:level_two_browse_content_item) do
      GovukSchemas::Example.find("mainstream_browse_page", example_name: "curated_level_2_page")
       .merge(
         "title" => "Level two browse page",
       )
    end

    let(:browse_content_item) do
      GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page")
       .merge(
         "base_path" => level_one_browse_url,
         "title" => "Level one browse page",
         "links" => { "second_level_browse_pages" => [level_two_browse_content_item] },
       )
    end

    before do
      allow(YAML).to receive(:load_file).and_return(test_yaml)
      stub_content_store_has_item(browse_content_item["base_path"], browse_content_item)
      topic_content_item = GovukSchemas::Example.find("topic", example_name: "curated_subtopic").merge(
        "title" => "Level two specialist topic",
        "base_path" => level_two_topic_url,
        "content_id" => "1234",
      )
      stub_content_store_has_item(level_two_topic_url, topic_content_item)

      search_api_has_documents_for_subtopic(
        topic_content_item["content_id"],
        %w[employee-tax-codes],
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )
    end

    scenario "the level two topics are visible on the level one browse grid" do
      visit browse_content_item["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_link("Level two browse page")
      expect(page).to have_link("Level two specialist topic")
    end

    scenario "clicking the level two specialist topic link" do
      visit browse_content_item["base_path"]
      click_link("Level two specialist topic")

      expect(page.status_code).to eq(200)
      expect(page).to have_selector("h1", text: "Level two specialist topic")
      expect(page).to have_selector("a.govuk-breadcrumbs__link", text: "Level one browse page")
    end
  end
end
