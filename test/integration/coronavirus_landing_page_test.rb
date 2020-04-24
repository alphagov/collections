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
      then_i_can_see_the_accordions
      and_i_can_see_links_to_search
    end

    it "has sections that can be clicked" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      and_i_click_on_an_accordion
      then_i_can_see_the_accordions_content
    end

    it "shows todays date when a live stream is enabled" do
      given_there_is_a_content_item_with_live_stream_enabled
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_live_stream_section_with_todays_date
    end

    it "optionally shows the time when a live stream is enabled" do
      given_there_is_a_content_item_with_live_stream_enabled_and_date
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_live_stream_section_with_date_and_time
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
      then_i_can_see_the_business_accordions
      and_i_can_see_business_links_to_search
    end
  end

  describe "the education hub page" do
    it "renders" do
      given_there_is_an_education_content_item
      when_i_visit_the_education_hub_page
      then_i_can_see_the_page_title("Education and Childcare")
    end
  end
end
