require "integration_test_helper"
require_relative "../support/coronavirus_landing_page_steps"

class CoronavirusLandingPageTest < ActionDispatch::IntegrationTest
  include CoronavirusLandingPageSteps

  describe "the coronavirus landing page" do
    it "renders" do
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_header_section
      then_i_can_see_the_nhs_banner
      then_i_can_see_the_accordians
    end

    it "has sections that can be clicked" do
      when_i_visit_the_coronavirus_landing_page
      and_i_click_on_an_accordian
      then_i_can_see_the_accordians_content
    end
  end
end
