require "integration_test_helper"

class DitLandingPageTest < ActionDispatch::IntegrationTest
  DIT_LANDING_PAGE_PATH = "/eubusiness".freeze

  describe "the DIT landing page" do
    it "renders" do
      when_i_visit_the_dit_landing_page
      then_i_can_see_the_header_section
      then_i_can_see_the_training_section
    end
  end

  def when_i_visit_the_dit_landing_page
    visit DIT_LANDING_PAGE_PATH
  end

  def then_i_can_see_the_header_section
    assert page.has_title? "Trade with the UK from 1 January 2021 as a business based in the EU"
  end

  def then_i_can_see_the_training_section
    assert page.has_selector?("h2", text: "Additional help and support")
    assert page.has_selector?(".govuk-table__row", text: "Date")
  end
end
