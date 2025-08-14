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

    scenario "renders the locale in <main> element" do
      expect(page).to have_css("main[lang='en']")
    end

    %w[
      govuk:public-updated-at
      govuk:updated-at
      govuk:first-published-at
      govuk:content-id
      govuk:schema-name
      govuk:rendering-app
      govuk:publishing-app
      govuk:format
    ].each do |meta_tag_name|
      scenario "renders the #{meta_tag_name} meta tag" do
        meta_tag = page.first("meta[name='#{meta_tag_name}']", visible: false)
        expect(meta_tag["content"]).to be_present
      end
    end
  end

  let(:content_item) { GovukSchemas::Example.find("world_index", example_name: "world_index") }
  let(:base_path) { content_item["base_path"] }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  context "when the GraphQL parameter is not set" do
    before do
      allow(Random).to receive(:rand).with(1.0).and_return(1)
      visit base_path
    end

    it_behaves_like "world index page"

    it "does not get the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).not_to have_been_made
    end
  end

  context "when the GraphQL parameter is true" do
    before do
      stub_publishing_api_graphql_has_item(base_path, content_item)

      visit "#{base_path}?graphql=true"
    end

    it_behaves_like "world index page"

    it "gets the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).to have_been_made
    end
  end

  context "when the GraphQL parameter is false" do
    before do
      visit "#{base_path}?graphql=false"
    end

    it "does not get the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).not_to have_been_made
    end
  end

  context "when the GraphQL A/B Content Store variant is selected" do
    before do
      allow(Random).to receive(:rand).with(1.0).and_return(1)
      visit base_path
    end

    it "does not get the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).not_to have_been_made
    end
  end

  context "when the GraphQL A/B GraphQL variant is selected" do
    before do
      stub_publishing_api_graphql_has_item(base_path, content_item)

      allow(Random).to receive(:rand).with(1.0).and_return(WorldController::GRAPHQL_TRAFFIC_RATE - 0.000001)
      visit base_path
    end

    it "gets the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).to have_been_made
    end
  end
end
