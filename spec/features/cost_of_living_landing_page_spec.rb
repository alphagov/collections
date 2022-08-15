require "integration_spec_helper"

RSpec.feature "Cost of Living hub page" do
  before do
    stub_content_store_does_not_have_item("/cost-of-living")
  end

  describe "the landing page" do
    scenario "renders" do
      when_i_visit_the_cost_of_living_landing_page
      then_i_can_see_the_title
      then_i_can_see_the_breadcrumbs
    end

    def when_i_visit_the_cost_of_living_landing_page
      visit cost_of_living_landing_page_path
    end

    def then_i_can_see_the_title
      expect(page).to have_title("Help for households")
    end

    def then_i_can_see_the_breadcrumbs
      expect(page).to have_css(".govuk-breadcrumbs__link", text: "Home")
    end
  end
end
