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
      then_i_can_see_the_nhs_banner
      then_i_can_see_the_timeline
      then_i_can_see_the_accordions
      and_i_can_see_links_to_search
      and_there_are_metatags
    end

    scenario "has sections that can be clicked" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      and_i_click_on_an_accordion
      then_i_can_see_the_accordions_content
    end

    scenario "shows COVID-19 risk level when risk level is enabled" do
      given_there_is_a_content_item_with_risk_level_element_enabled
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_risk_level
    end

    scenario "does not show COVID-19 risk level when risk level is not enabled" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_i_can_not_see_the_risk_level
    end

    scenario "renders machine readable content" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_the_special_announcement_schema_is_rendered
      and_the_faqpage_schema_is_rendered
    end

    describe "selecting timeline for country" do
      scenario "with javascript", js: true do
        given_there_is_a_content_item_with_timeline_national_applicability
        when_i_visit_the_coronavirus_landing_page
        then_i_can_see_the_timeline_for_england
        when_i_click_on_wales
        then_i_can_see_the_timeline_for_wales
      end

      scenario "without javascript" do
        given_there_is_a_content_item_with_timeline_national_applicability
        when_i_visit_the_coronavirus_landing_page
        then_i_can_see_the_timeline_for_england
        when_i_click_on_wales
        and_i_submit_my_nation
        then_i_can_see_the_timeline_for_wales
      end
    end
  end

  describe "the business support hub page" do
    scenario "renders" do
      given_there_is_a_business_content_item
      when_i_visit_the_business_hub_page
      then_i_can_see_the_business_page
      then_i_cannot_see_the_education_header_section
      then_i_can_see_the_business_accordions
      and_i_can_see_business_links_to_search
    end
  end

  describe "the education hub page" do
    scenario "renders" do
      given_there_is_an_education_content_item
      when_i_visit_the_education_hub_page
      then_i_can_see_the_page_title("Education and Childcare")
      then_i_can_see_the_education_header_section
      then_i_can_see_the_education_accordions
    end
  end

  describe "redirects from the taxon" do
    scenario "redirects /coronavirus-taxon to the landing page" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_taxon_page
      then_i_am_redirected_to_the_landing_page
    end

    scenario "redirects taxons to appropriate hub pages" do
      given_there_is_a_business_content_item
      and_a_coronavirus_business_taxon
      when_i_visit_the_coronavirus_business_taxon
      then_i_am_redirected_to_the_business_hub_page
    end

    scenario "redirects subtaxons to appropriate hub pages" do
      given_there_is_a_business_content_item
      and_a_coronavirus_business_subtaxon
      when_i_visit_the_coronavirus_business_subtaxon
      then_i_am_redirected_to_the_business_hub_page
    end

    scenario "redirects subtaxons to the landing page if there is no overriding rule" do
      given_there_is_a_content_item
      and_another_coronavirus_subtaxon
      when_i_visit_a_coronavirus_subtaxon_without_a_hub_page
      then_i_am_redirected_to_the_landing_page
    end
  end
end
