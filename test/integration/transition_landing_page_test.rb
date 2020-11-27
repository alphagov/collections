require "integration_test_helper"
require_relative "../support/transition_landing_page_steps"

class TransitionLandingPageTest < ActionDispatch::IntegrationTest
  include TransitionLandingPageSteps

  describe "the transition landing page" do
    it "renders" do
      given_there_is_a_transition_taxon
      when_i_visit_the_transition_landing_page
      then_i_can_see_the_take_action_section
      then_i_can_see_the_title_section
      then_i_can_see_the_header_section
      then_i_can_see_the_buckets_section
      then_i_can_see_the_share_links_section
      and_i_can_see_the_explore_topics_section
      and_there_is_metadata
    end

    it "has tracking on all links" do
      given_there_is_a_transition_taxon
      when_i_visit_the_transition_landing_page
      then_all_finder_links_have_tracking_data
      and_ecommerce_tracking_is_setup
    end

    it "is not noindexed" do
      given_there_is_a_transition_taxon
      when_i_visit_the_transition_landing_page
      then_the_page_is_not_noindexed
    end

    it "does not show the dynamic list" do
      given_there_is_a_transition_taxon
      when_i_visit_the_transition_landing_page
      then_i_cannot_see_the_get_ready_section
    end
  end
end
