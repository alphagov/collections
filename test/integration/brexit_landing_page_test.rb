require 'integration_test_helper'
require_relative '../support/brexit_landing_page_steps'

class BrexitLandingPageTest < ActionDispatch::IntegrationTest
  include BrexitLandingPageSteps

  it 'renders the brexit page' do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_i_can_see_the_title_section
    then_i_can_see_navigation_to_brexit_pages
    and_i_can_see_the_email_signup_link
    and_i_can_see_the_services_section
    and_i_can_see_the_guidance_and_regulation_section
    and_i_can_see_the_news_and_communications_section
    and_i_can_see_the_policy_papers_and_consulations_section
    and_i_can_see_the_transparency_and_foi_releases_section
    and_i_can_see_the_research_and_statistics_section
    and_i_can_see_the_organisations_section
  end

  it 'renders an in-page nav' do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    and_i_can_see_the_in_page_nav
  end

  it "has tracking on all links" do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_all_links_have_tracking_data
  end
end
