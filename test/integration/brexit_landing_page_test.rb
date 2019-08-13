require 'integration_test_helper'
require_relative '../support/brexit_landing_page_steps'

class BrexitLandingPageTest < ActionDispatch::IntegrationTest
  include BrexitLandingPageSteps

  it 'renders the brexit page' do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_i_can_see_the_title_section
    then_i_can_see_the_header_section
    then_i_can_see_the_get_ready_section
    then_i_can_see_the_share_links_section
    then_i_can_see_the_buckets_section
    and_i_can_see_the_explore_topics_section
    and_i_can_see_an_email_subscription_link
  end

  it "has tracking on all links" do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_all_finder_links_have_tracking_data
    and_the_start_button_is_tracked
    and_bucket_section_headings_are_tracked
    and_the_email_link_is_tracked
  end
end
