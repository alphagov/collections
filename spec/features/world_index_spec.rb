require "integration_spec_helper"

RSpec.feature "World index page" do
  shared_examples "world index page" do
    scenario "returns 200 when visiting world index page" do
      expect(page.status_code).to eq(200)
    end

    scenario "renders breadcrumbs" do
      within ".gem-c-breadcrumbs" do
        expect(page).to have_link("Home", href: "/")
      end
    end

    scenario "renders the webpage title" do
      expect(page).to have_title("Help and services around the world - GOV.UK")
    end

    scenario "renders the page title" do
      expect(page).to have_selector(".gem-c-heading__text", text: "Help and services around the world")
    end

    scenario "renders a link to all foreign office posts" do
      expect(page).to have_link("list of overseas Foreign, Commonwealth & Development Office posts", href: "/government/publications/list-of-foreign-office-posts")
    end

    scenario "renders links to world locations when they are active" do
      z_links = page.find(".world-locations-group__letter", text: "Z").sibling("ol")

      within z_links do
        expect(page).to have_link("Zambia", href: "/world/zambia")
      end
    end

    scenario "renders world location names as text when they are inactive" do
      u_links = page.find(".world-locations-group__letter", text: "U").sibling("ol")

      within u_links do
        expect(page).to have_content("United Kingdom")
        expect(page).to_not have_link("United Kingdom")
      end
    end

    scenario "renders links to international delegations" do
      international_delegations_section = page.find("section", id: "international-delegations")

      within international_delegations_section do
        expect(page).to have_link("The UK Permanent Delegation to the OECD (Organisation for Economic Co-operation and Development)", href: "/world/the-uk-permanent-delegation-to-the-oecd-organisation-for-economic-co-operation-and-development")
      end
    end

    scenario "renders links with GA4 tracking" do
      ga4_module = "ol[data-module=ga4-link-tracker]"
      expect(page).to have_css(ga4_module)
      expect(page).to have_css("ol[data-ga4-track-links-only]")

      ga4_link_data = JSON.parse(page.first(ga4_module)["data-ga4-link"])
      expect(ga4_link_data["event_name"]).to eq "navigation"
      expect(ga4_link_data["type"]).to eq "filter"
    end

    scenario "renders the filter input box with GA4 tracking" do
      ga4_module = ".filter-list__form input[data-module=ga4-focus-loss-tracker]"
      expect(page).to have_css(ga4_module)

      ga4_focus_loss_data = JSON.parse(page.first(ga4_module)["data-ga4-focus-loss"])
      expect(ga4_focus_loss_data["event_name"]).to eq "filter"
      expect(ga4_focus_loss_data["type"]).to eq "filter"
      expect(ga4_focus_loss_data["action"]).to eq "filter"
      expect(ga4_focus_loss_data["section"]).to eq "Help and services around the world"
    end
  end

  before do
    stub_content_store_has_item("/world", GovukSchemas::Example.find("world_index", example_name: "world_index"))
  end

  context "when the GraphQL parameter is not set" do
    before do
      visit "/world"
    end

    it_behaves_like "world index page"

    it "does not get the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
    end
  end

  context "when the GraphQL parameter is true" do
    before do
      stub_publishing_api_graphql_query(
        Graphql::WorldIndexQuery.new("/world").query,
        fetch_graphql_fixture("world_index"),
      )

      visit "/world?graphql=true"
    end

    it "gets the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).to have_been_made
    end
  end

  context "when the GraphQL parameter is false" do
    before do
      visit "/world?graphql=false"
    end

    it "does not get the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
    end
  end
end
