require "integration_test_helper"
require_relative "../support/coronavirus_landing_page_steps"

class CoronavirusLandingPageTest < ActionDispatch::IntegrationTest
  include CoronavirusLandingPageSteps

  describe "the coronavirus landing page" do
    it "renders" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_header_section
      then_i_can_see_the_nhs_banner
      then_i_can_see_the_timeline
      then_i_can_see_the_accordions
      then_i_can_see_the_live_stream_section
      and_i_can_see_links_to_search
      and_there_are_metatags
    end

    it "has sections that can be clicked" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      and_i_click_on_an_accordion
      then_i_can_see_the_accordions_content
    end

    it "displays all livestream information" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_live_stream_section_with_streamed_date
      then_i_can_see_the_ask_a_question_section
      then_i_can_see_the_popular_questions_link
    end

    it "can hide the livestream section" do
      given_there_is_a_content_item_with_livestream_disabled
      when_i_visit_the_coronavirus_landing_page
      then_i_cannot_see_the_live_stream_section
    end

    it "optionally shows the time of a livestream" do
      given_there_is_a_content_item_with_live_stream_time
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_live_stream_section_with_date_and_time
    end

    it "optionally hides the ask a question link" do
      given_there_is_a_content_item_with_ask_a_question_disabled
      when_i_visit_the_coronavirus_landing_page
      then_i_cannot_see_the_ask_a_question_section
    end

    it "optionally hides the popular questions link" do
      given_there_is_a_content_item_with_popular_questions_link_disabled
      when_i_visit_the_coronavirus_landing_page
      then_i_cannot_see_the_popular_questions_link
    end

    it "shows COVID-19 risk level when risk level is enabled" do
      given_there_is_a_content_item_with_risk_level_element_enabled
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_risk_level
    end

    it "does not show COVID-19 risk level when risk level is not enabled" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_i_can_not_see_the_risk_level
    end

    it "renders machine readable content" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_the_special_announcement_schema_is_rendered
      and_the_faqpage_schema_is_rendered
    end
  end

  describe "the business support hub page" do
    it "renders" do
      given_there_is_a_business_content_item
      when_i_visit_the_business_hub_page
      then_i_can_see_the_business_page
      then_i_cannot_see_the_education_header_section
      then_i_can_see_the_business_accordions
      and_i_can_see_business_links_to_search
    end
  end

  describe "the education hub page" do
    it "renders" do
      given_there_is_an_education_content_item
      when_i_visit_the_education_hub_page
      then_i_can_see_the_page_title("Education and Childcare")
      then_i_can_see_the_education_header_section
      then_i_can_see_the_education_accordions
    end
  end

  describe "redirects from the taxon" do
    it "redirects /coronavirus-taxon to the landing page" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_taxon_page
      then_i_am_redirected_to_the_landing_page
    end

    it "redirects taxons to appropriate hub pages" do
      given_there_is_a_business_content_item
      and_a_coronavirus_business_taxon
      when_i_visit_the_coronavirus_business_taxon
      then_i_am_redirected_to_the_business_hub_page
    end

    it "redirects subtaxons to appropriate hub pages" do
      given_there_is_a_business_content_item
      and_a_coronavirus_business_subtaxon
      when_i_visit_the_coronavirus_business_subtaxon
      then_i_am_redirected_to_the_business_hub_page
    end

    it "redirects subtaxons to the landing page if there is no overriding rule" do
      given_there_is_a_content_item
      and_another_coronavirus_subtaxon
      when_i_visit_a_coronavirus_subtaxon_without_a_hub_page
      then_i_am_redirected_to_the_landing_page
    end
  end
end
