require "integration_test_helper"
require_relative "../support/transition_landing_page_steps"

class TransitionLandingPageTest < ActionDispatch::IntegrationTest
  include TransitionLandingPageSteps

  context "when there should be a dynamic list" do
    it "renders the brexit page" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_transition_landing_page_with_dynamic_list
      then_i_can_see_the_buckets_section
      then_i_can_see_the_title_section
      then_i_can_see_the_header_section
      then_i_can_see_the_what_happens_next_section
      then_i_can_see_the_share_links_section
      and_i_can_see_the_explore_topics_section
      and_i_can_see_an_email_subscription_link
    end

    it "has tracking on all links" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_transition_landing_page_with_dynamic_list
      then_all_finder_links_have_tracking_data
      and_the_email_link_is_tracked
      and_ecommerce_tracking_is_setup
    end

    it "is not noindexed" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_transition_landing_page_with_dynamic_list
      then_the_page_is_not_noindexed
    end
  end

  context "when there should not be a dynamic list" do
    it "does not show the list" do
      given_there_is_a_brexit_taxon
      when_i_visit_the_transition_landing_page_without_dynamic_list
      then_i_cannot_see_the_get_ready_section
    end
  end
end
