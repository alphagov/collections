require 'integration_test_helper'
require_relative '../support/brexit_landing_page_steps'

class BrexitLandingPageTest < ActionDispatch::IntegrationTest
  include BrexitLandingPageSteps

  it 'renders the brexit page' do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_i_can_see_the_title_section
    and_i_can_see_the_explore_topics_section
  end

  it "has tracking on all links" do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_all_links_have_tracking_data
  end
end
