require "integration_test_helper"
require_relative "../support/coronavirus_landing_page_steps"

class CoronavirusLandingPageTest < ActionDispatch::IntegrationTest
  include CoronavirusLandingPageSteps

  describe "the coronavirus landing page" do
    it "renders" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_header_section
      and_i_can_see_the_live_stream_section
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

    it "optionally shows the time" do
      given_there_is_a_content_item_with_no_time
      when_i_visit_the_coronavirus_landing_page
      then_i_can_see_the_live_stream_section_with_no_time
    end

    it "renders machine readable content" do
      given_there_is_a_content_item
      when_i_visit_the_coronavirus_landing_page
      then_the_special_announcement_schema_is_rendered
      and_the_faqpage_schema_is_rendered
    end
  end

  describe "the business support landing page" do
    it "renders" do
      given_there_is_a_business_content_item
      when_i_visit_the_business_landing_page
      then_i_can_see_the_business_header_section
      # and_i_can_see_the_business_announcements
      then_i_can_see_the_business_accordions
      and_i_can_see_business_links_to_search
      and_i_can_see_related_links
    end
  end
end
