require "integration_spec_helper"

RSpec.feature "Subtopic pages" do
  include SearchApiHelpers

  def oil_and_gas_subtopic_item(subtopic_slug, params = {})
    base = {
      content_id: "content-id-for-#{subtopic_slug}",
      base_path: "/topic/oil-and-gas/#{subtopic_slug}",
      title: subtopic_slug.humanize,
      description: "Offshore drilling and exploration",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {
        groups: [],
      },
      links: {
        "parent" => [
          "title" => "Oil and Gas",
          "base_path" => "/topic/oil-and-gas",
        ],
      },
    }
    base[:details].merge!(params.delete(:details)) if params.key?(:details)
    base.merge(params)
  end

  before do
    search_api_has_documents_for_subtopic(
      "content-id-for-offshore",
      %w[
        oil-rig-safety-requirements
        oil-rig-staffing
        north-sea-shipping-lanes
        undersea-piping-restrictions
      ],
      page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
    )
  end

  scenario "renders a curated subtopic" do
    # Given a curated subtopic exists
    stub_content_store_has_item(
      "/topic/oil-and-gas/offshore",
      oil_and_gas_subtopic_item(
        "offshore",
        details: {
          groups: [
            {
              name: "Oil rigs",
              contents: [
                "/oil-rig-staffing",
                "/oil-rig-safety-requirements",
              ],
            },
            {
              name: "Piping",
              contents: [
                "/undersea-piping-restrictions",
              ],
            },
          ],
        },
      ),
    )

    stub_topic_organisations("oil-and-gas/offshore", "content-id-for-offshore")

    # When I visit the subtopic page
    visit "/topic/oil-and-gas/offshore"

    # Then it should have the correct page title
    expect(page).to have_title("Oil and Gas: Offshore - detailed information - GOV.UK")

    # Then I should see the subtopic metadata
    within ".page-header" do
      within ".gem-c-title" do
        expect(page).to have_selector(".gem-c-title__text", text: "Offshore: detailed information")
        expect(page).to have_selector(".gem-c-title__context", text: "Oil and Gas")
      end

      within ".gem-c-metadata" do
        # The orgs are fixed in the search_api test helpers
        expect(page).to have_content("Department of Energy & Climate Change")
        expect(page).to have_content("Foreign & Commonwealth Office")
      end
    end

    # And I should see the curated content for the subtopic
    expect(page).to have_link("Oil rig staffing", href: "/oil-rig-staffing")
    expect(page).to have_link("Oil rig safety requirements", href: "/oil-rig-safety-requirements")
    expect(page).to have_link("Undersea piping restrictions", href: "/undersea-piping-restrictions")

    expect(page).not_to have_link("North sea shipping")

    within ".gem-c-breadcrumbs" do
      expect(page).to have_link("Home", href: "/")
      expect(page).to have_link("Oil and Gas", href: "/topic/oil-and-gas")
    end
  end

  it "renders a non-curated subtopic" do
    # Given a non-curated subtopic exists
    stub_content_store_has_item("/topic/oil-and-gas/offshore", oil_and_gas_subtopic_item("offshore"))
    stub_topic_organisations("oil-and-gas/offshore", "content-id-for-offshore")

    # When I visit the subtopic page
    visit "/topic/oil-and-gas/offshore"

    # Then I should see the subtopic metadata
    within ".page-header" do
      within ".gem-c-title" do
        expect(page).to have_selector(".gem-c-title__text", text: "Offshore")
        expect(page).to have_selector(".gem-c-title__context", text: "Oil and Gas")
      end

      within ".gem-c-metadata" do
        expect(page).to have_content("Department of Energy & Climate Change")
        expect(page).to have_content("Foreign & Commonwealth Office")
      end
    end

    # And I should see all content for the subtopic
    expect(page).to have_link("Oil rig staffing", href: "/oil-rig-staffing")
    expect(page).to have_link("Oil rig safety requirements", href: "/oil-rig-safety-requirements")
    expect(page).to have_link("North sea shipping lanes", href: "/north-sea-shipping-lanes")
    expect(page).to have_link("Undersea piping restrictions", href: "/undersea-piping-restrictions")

    expect(page).to have_selector(".gem-c-breadcrumbs")
  end

  describe "latest page for a subtopic" do
    before do
      stub_content_store_has_item("/topic/oil-and-gas/offshore", oil_and_gas_subtopic_item("offshore"))
      stub_topic_organisations("oil-and-gas/offshore", "content-id-for-offshore")
    end

    it "displays the latest page" do
      # Given there is latest content for a subtopic
      search_api_has_latest_documents_for_subtopic(
        "content-id-for-offshore",
        %w[
          oil-and-gas-uk-field-data
          oil-and-gas-wells
          oil-and-gas-fields-and-field-development
          oil-and-gas-geoscientific-data
        ],
      )

      # When I view the latest page for a subtopic
      visit "/topic/oil-and-gas/offshore"
      click_on I18n.t("subtopics.get_latest")

      # Then I should see the subtopic metadata
      within ".page-header" do
        within ".gem-c-title" do
          expect(page).to have_selector(".gem-c-title__text", text: "Latest documents")
          expect(page).to have_selector(".gem-c-title__context", text: "Offshore")
        end

        within ".gem-c-metadata" do
          # The orgs are fixed in the search_api test helpers
          expect(page).to have_content("Department of Energy & Climate Change")
          expect(page).to have_content("Foreign & Commonwealth Office")
        end
      end

      # And I should see the latest documents for the subtopic in date order
      titles = page.all(".gem-c-document-list__item-title").map(&:text)
      expected_titles = [
        "Oil and gas uk field data",
        "Oil and gas wells",
        "Oil and gas fields and field development",
        "Oil and gas geoscientific data",
      ]
      expect(titles).to eq(expected_titles)
    end

    fit "paginates the results" do
      # Given there is latest content for a subtopic
      search_api_has_latest_documents_for_subtopic(
        "content-id-for-offshore",
        (1..55).map { |n| "document-#{n}" },
      )

      # When I view the latest page for a subtopic
      visit "/topic/oil-and-gas/offshore"
      click_on I18n.t("subtopics.get_latest")

      # Then I should see the first 50 documents
      within ".gem-c-document-list" do
        expect(page).to have_content("Document 1")
        expect(page).to have_content("Document 50")
        expect(page).not_to have_content("Document 51")
      end

      # When I go to the next page
      expect(page).to have_selector(".govuk-pagination")
      next_href = page.find(".govuk-pagination__link[rel='next']")["href"]
      visit next_href

      # Then I should see the remaining documents
      within ".gem-c-document-list" do
        expect(page).to have_content("Document 51")
        expect(page).to have_content("Document 55")
        expect(page).not_to have_content("Document 1")
        expect(page).not_to have_content("Document 50")
      end

      # When I go back to the first page
      expect(page).to have_selector(".govuk-pagination")
      prev_href = page.find(".govuk-pagination__link[rel='prev']")["href"]
      visit prev_href

      # Then I should see the first 50 documents again
      within ".gem-c-document-list" do
        expect(page).to have_content("Document 1")
        expect(page).to have_content("Document 50")
        expect(page).not_to have_content("Document 51")
      end
    end
  end

  it "adds tracking attributes to links within sections" do
    # Given a curated subtopic exists
    stub_content_store_has_item(
      "/topic/oil-and-gas/offshore",
      oil_and_gas_subtopic_item(
        "offshore",
        details: {
          groups: [
            {
              name: "Oil rigs",
              contents: [
                "/oil-rig-safety-requirements",
              ],
            },
            {
              name: "Piping",
              contents: [
                "/undersea-piping-restrictions",
              ],
            },
          ],
        },
      ),
    )

    stub_topic_organisations("oil-and-gas/offshore", "content-id-for-offshore")

    visit "/topic/oil-and-gas/offshore"

    expect(page).to have_selector('.browse-container[data-module="gem-track-click"]')

    oil_rig_safety_requirements = page.find(
      "a",
      text: "Oil rig safety requirements",
    )

    expect(oil_rig_safety_requirements["data-track-category"]).to eq("navSubtopicContentItemLinkClicked")

    expect(oil_rig_safety_requirements["data-track-action"]).to eq("1.1")

    expect(oil_rig_safety_requirements["data-track-label"]).to eq("/oil-rig-safety-requirements")

    expect(oil_rig_safety_requirements["data-track-options"]).to be_present

    data_options = JSON.parse(oil_rig_safety_requirements["data-track-options"])
    expect(data_options["dimension28"]).to eq("1")

    expect(data_options["dimension29"]).to eq("Oil rig safety requirements")

    undersea_piping_restrictions = page.find(
      "a",
      text: "Undersea piping restrictions",
    )

    expect(undersea_piping_restrictions["data-track-category"]).to eq("navSubtopicContentItemLinkClicked")

    expect(undersea_piping_restrictions["data-track-action"]).to eq("2.1")

    expect(undersea_piping_restrictions["data-track-label"]).to eq("/undersea-piping-restrictions")

    expect(undersea_piping_restrictions["data-track-options"]).to be_present

    data_options = JSON.parse(undersea_piping_restrictions["data-track-options"])
    expect(data_options["dimension28"]).to eq("1")

    expect(data_options["dimension29"]).to eq("Undersea piping restrictions")
  end
end
