require "integration_test_helper"
require "gds_api/test_helpers/mapit"
require_relative "../support/coronavirus_local_restrictions_helpers"

class CoronavirusLocalRestrictionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentStore
  include CoronavirusLocalRestrictionsHelpers

  #   Consider writing view tests in test/views/coronavirus_local_restrictions/ to test rendering page information.
  #
  #   Integration tests should still be used to test users journeys. However, the number of these may be decreased
  #   by testing all possible outcomes using view tests and the general user journeys using integration tests.

  it "displays restrictions for an area with restrictions" do
    given_i_am_on_the_local_restrictions_page
    when_i_enter_a_valid_english_postcode_for_a_restriction_area
    then_i_click_on_find
    then_i_see_the_restriction_information
  end

  it "displays guidance for a devolved nation" do
    given_i_am_on_the_local_restrictions_page
    when_i_enter_a_postcode_for_a_devolved_nation_area
    then_i_click_on_find
    then_i_see_the_devolved_nation_guidance
  end

  it "displays no information for an area without tier information" do
    given_i_am_on_the_local_restrictions_page
    when_i_enter_a_valid_english_postcode_with_no_tier_information
    then_i_click_on_find
    then_i_see_the_no_information_page
  end

  describe "with javascript" do
    before { Capybara.current_driver = Capybara.javascript_driver }
    after { Capybara.use_default_driver }

    it "normalises the submitted postcode" do
      given_i_am_on_the_local_restrictions_page
      when_i_enter_an_unusually_formatted_postcode
      then_i_click_on_find
      then_i_see_the_results_with_conventional_postcode_formatting
    end
  end

  def given_i_am_on_the_local_restrictions_page
    stub_content_store_has_item("/find-coronavirus-local-restrictions", {})

    visit find_coronavirus_local_restrictions_path
  end

  def when_i_enter_a_valid_english_postcode_with_no_tier_information
    @area = "Tattooine"
    postcode = "E1 8QS"
    stub_no_local_restriction(postcode: postcode, name: @area)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def when_i_enter_an_unusually_formatted_postcode
    @postcode = "E1 8QS"
    @area = "Hoth"
    stub_local_restriction(postcode: @postcode, name: @area, current_alert_level: 1)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: "e18qs"
  end

  def when_i_enter_a_valid_english_postcode_for_a_restriction_area
    @area = "Coruscant Planetary Council"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: "E1 8QS", name: @area, current_alert_level: 1)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def when_i_enter_a_postcode_for_a_devolved_nation_area
    postcode = "LL11 0BY"
    stub_local_restriction(postcode: postcode, country_name: "Wales")

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_click_on_find
    click_on "Find"
  end

  def then_i_see_the_results_with_conventional_postcode_formatting
    assert page.has_text?(@area)
    assert page.has_text?(@postcode)
    assert page.current_url.match?(/postcode=#{Regexp.escape(CGI.escape(@postcode))}/)
  end

  def then_i_see_the_restriction_information
    heading = "#{I18n.t('coronavirus_local_restrictions.results.level_one.heading_pretext')} #{I18n.t('coronavirus_local_restrictions.results.level_one.heading_tier_label')}"
    assert page.has_text?(@area)
    assert page.has_text?(heading)
  end

  def then_i_see_the_devolved_nation_guidance
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.devolved_nations.wales.guidance.label"))
  end

  def then_i_see_the_no_information_page
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.no_information.heading"))
  end
end
