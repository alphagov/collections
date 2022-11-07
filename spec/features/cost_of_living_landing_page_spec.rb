require "integration_spec_helper"

RSpec.feature "Cost of Living hub page" do
  before do
    stub_content_store_has_item("/cost-of-living")
  end

  describe "the landing page" do
    scenario "renders" do
      when_i_visit_the_cost_of_living_landing_page
      then_i_can_see_the_title
      then_i_can_see_the_breadcrumbs
      and_there_are_metatags
      and_there_is_the_announcements_section
      and_there_is_an_important_info_suffix_on_some_link
      and_there_is_link_tracking
      and_there_is_accordion_section_tracking
    end

    def when_i_visit_the_cost_of_living_landing_page
      visit cost_of_living_landing_page_path
    end

    def then_i_can_see_the_title
      expect(page).to have_title("Cost of living support")
    end

    def then_i_can_see_the_breadcrumbs
      expect(page).to have_css(".govuk-breadcrumbs__link", text: "Home")
    end

    def and_there_are_metatags
      expect(page).to have_selector(
        "meta[property='og:title'][content='Cost of living support']",
        visible: false,
      )
      expect(page).to have_selector(
        "meta[name='description'][content='Find out what support is available to help with the cost of living. This includes income and disability benefits, bills and allowances, childcare, housing and travel.']",
        visible: false,
      )
      expect(page).to have_selector("meta[name='govuk:navigation-page-type'][content='Cost of living hub']", visible: false)
      expect(page).to have_selector("meta[name='govuk:navigation-list-type'][content='curated']", visible: false)
    end

    def and_there_is_the_announcements_section
      expect(page).to have_text("Announcements")
    end

    def and_there_is_an_important_info_suffix_on_some_link
      expect(page).to have_text("opens 14 November 2022")
    end

    def and_there_is_link_tracking
      link = page.find(".govuk-list a.govuk-link", text: "Find out how the Energy Price Guarantee limits your energy prices")

      expect(link["data-track-category"]).to eq("contentsClicked")
      expect(link["data-track-action"]).to eq("Support with your bills")
      expect(link["data-track-label"]).to eq("/government/publications/energy-bills-support/energy-bills-support-factsheet-8-september-2022")
      expect(link["data-track-count"]).to eq("contentLink")
    end

    def and_there_is_accordion_section_tracking
      accordion_section = page.first(".govuk-accordion__section-heading")

      expect(accordion_section["data-track-count"]).to eq("accordionSection")
    end
  end
end
