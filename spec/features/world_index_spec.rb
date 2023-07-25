require "integration_spec_helper"

RSpec.feature "World index page" do
  before do
    stub_content_store_has_item("/world", GovukSchemas::Example.find("world_index", example_name: "world_index"))
    visit "/world"
  end

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
    expect(page).to have_selector(".gem-c-title__text", text: "Help and services around the world")
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
end
