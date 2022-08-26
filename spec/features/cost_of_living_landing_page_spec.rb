require "integration_spec_helper"

RSpec.feature "Cost of Living hub page" do
  before do
    stub_content_store_has_item("/cost-of-living")
  end

  describe "the landing page" do
    before do
      allow(Rails.configuration).to receive(:unreleased_features).and_return(true)
    end

    scenario "renders" do
      when_i_visit_the_cost_of_living_landing_page
      then_i_can_see_the_title
      then_i_can_see_the_breadcrumbs
      and_there_are_metatags
      and_there_is_link_clicked_tracking
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
        "meta[name='description'][content='Find out what support is available to help with the cost of living. This includes income and disability benefits, bills and allowances, childcare, housing and transport.']",
        visible: false,
      )
    end

    def and_there_is_link_clicked_tracking
      link = page.find("a", text: "Find out what benefits and financial support you may be able to get")

      expect(link["data-track-category"]).to eq("contentsClicked")
      expect(link["data-track-action"]).to eq("Support with your income")
      expect(link["data-track-label"]).to eq("check-benefits-financial-support")
    end
  end
end
