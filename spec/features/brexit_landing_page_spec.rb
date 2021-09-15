require "integration_spec_helper"

RSpec.feature "Brexit landing page" do
  include BrexitLandingPageSteps

  describe "the transition landing page" do
    it "renders" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_brexit_landing_page
      then_i_can_see_the_title_section
      then_i_can_see_the_header_section
      and_i_can_see_the_explore_topics_section
      and_there_is_metadata
      and_the_faqpage_schema_is_rendered
    end

    it "has tracking on all links" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_brexit_landing_page
      then_all_finder_links_have_tracking_data
    end

    it "is not noindexed" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_brexit_landing_page
      then_the_page_is_not_noindexed
    end

    it "does not show the dynamic list" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_brexit_landing_page
      then_i_cannot_see_the_get_ready_section
    end
  end
end
