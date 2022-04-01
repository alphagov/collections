require "integration_spec_helper"

RSpec.feature "Coronavirus Pages" do
  include CoronavirusLandingPageSteps
  include CoronavirusContentItemHelper

  describe "the landing page" do
    before { stub_coronavirus_statistics }

    scenario "renders" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_header_section
      then_i_can_see_the_accordions
      and_i_can_see_links_to_search
      and_there_are_metatags
    end

    scenario "has accordions with sub headings" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_sub_headings_of_accordions
    end

    scenario "renders machine readable content" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_the_special_announcement_schema_is_rendered
      and_the_faqpage_schema_is_rendered
    end
  end

  describe "redirects from the taxon" do
    scenario "redirects /coronavirus-taxon to the landing page" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_taxon_page
      then_i_am_redirected_to_the_landing_page
    end

    scenario "redirects subtaxons to the landing page if there is no overriding rule" do
      given_there_is_a_content_item
      and_another_coronavirus_subtaxon
      when_i_visit_a_coronavirus_subtaxon_without_a_hub_page
      then_i_am_redirected_to_the_landing_page
    end
  end
end
