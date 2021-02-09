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

  describe "current restrictions" do
    it "displays the tier one restrictions" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      and_there_is_metadata
      then_i_enter_a_valid_english_postcode_in_tier_one
      then_i_click_on_find
      then_i_see_the_results_page_for_level_one
    end

    it "displays no tier information" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_english_postcode_with_no_tier_information
      then_i_click_on_find
      then_i_see_the_no_information_page
    end
  end

  describe "devolved_nations" do
    it "displays guidance for a devolved nation" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_welsh_postcode
      then_i_click_on_find
      then_i_see_the_results_for_wales
    end
  end

  describe "with javascript" do
    before { Capybara.current_driver = Capybara.javascript_driver }
    after { Capybara.use_default_driver }

    it "normalises the submitted postcode" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_an_unusually_formatted_postcode
      then_i_click_on_find
      then_i_see_the_results_with_conventional_postcode_formatting
    end
  end

  describe "errors" do
    it "errors gracefully if the postcode is invalid" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      when_i_enter_an_invalid_postcode
      then_i_click_on_find
      then_i_can_see_the_invalid_postcode_in_the_form
      then_i_see_an_invalid_postcode_error_message
    end
  end

  it "displays no information found if the postcode is in a valid format, but there is no data" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    when_i_enter_a_valid_postcode_that_returns_no_results
    then_i_click_on_find
    then_i_see_the_no_information_page
  end

  describe "future restrictions" do
    it "displays restrictions changing from level one to level two" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_with_a_future_level_two_restriction
      then_i_click_on_find
      then_i_see_the_results_page_for_level_one_with_changing_restriction_levels
    end
  end

  describe "when the restrictions are out of date" do
    before do
      CoronavirusLocalRestrictionsController.any_instance.stubs(:out_of_date?).returns(true)
    end

    it "displays an out of date warning on the lookup page" do
      given_i_am_on_the_local_restrictions_page
      then_i_see_an_out_of_date_warning
    end

    it "displays an out of date warning on the tier one page" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_in_tier_one
      then_i_click_on_find
      then_i_see_an_out_of_date_warning
    end
  end

  describe "when the restrictions are up to date" do
    before do
      CoronavirusLocalRestrictionsController.any_instance.stubs(:out_of_date?).returns(false)
    end

    it "does not display an out of date warning on the lookup page" do
      given_i_am_on_the_local_restrictions_page
      then_i_do_not_see_an_out_of_date_warning
    end
  end

  def given_i_am_on_the_local_restrictions_page
    stub_content_store_has_item("/find-coronavirus-local-restrictions", {})

    visit find_coronavirus_local_restrictions_path
  end

  def then_i_can_see_the_postcode_lookup_form
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.lookup.title"))
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.lookup.input_label"))
  end

  def then_i_can_see_the_invalid_postcode_in_the_form
    field = page.find_field(I18n.t("coronavirus_local_restrictions.lookup.input_label"))
    assert_equal @postcode, field.value
  end

  def then_i_enter_a_valid_english_postcode_with_no_tier_information
    @area = "Tattooine"
    postcode = "E1 8QS"
    stub_no_local_restriction(postcode: postcode, name: @area)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_an_unusually_formatted_postcode
    @postcode = "E1 8QS"
    @area = "Hoth"
    stub_local_restriction(postcode: @postcode, name: @area, current_alert_level: 1)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: "e18qs"
  end

  def then_i_enter_a_valid_english_postcode_with_a_future_level_two_restriction
    @area = "Naboo"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: postcode,
                           name: @area,
                           current_alert_level: 1,
                           future_alert_level: 2)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_english_postcode_in_tier_one
    @area = "Coruscant Planetary Council"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: "E1 8QS", name: @area, current_alert_level: 1)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_welsh_postcode
    postcode = "LL11 0BY"
    stub_local_restriction(postcode: postcode, country_name: "Wales")

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def when_i_enter_a_valid_postcode_that_returns_no_results
    postcode = "IM1 1AF"
    mapit_endpoint = Plek.current.find("mapit")

    stub_request(:get, "#{mapit_endpoint}/postcode/" + postcode.tr(" ", "+") + ".json")
        .to_return(body: { "postcode" => postcode.to_s, "areas" => {} }.to_json, status: 200)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def when_i_enter_an_invalid_postcode
    @postcode = "Hello"
    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: @postcode
  end

  def then_i_click_on_find
    click_on "Find"
  end

  def then_i_see_the_results_with_conventional_postcode_formatting
    assert page.has_text?(@area)
    assert page.has_text?(@postcode)
    assert page.current_url.match?(/postcode=#{Regexp.escape(CGI.escape(@postcode))}/)
  end

  def then_i_see_the_results_page_for_level_one
    heading = "#{I18n.t('coronavirus_local_restrictions.results.level_one.heading_pretext')} #{I18n.t('coronavirus_local_restrictions.results.level_one.heading_tier_label')}"
    assert page.has_text?(@area)
    assert page.has_text?(heading)
  end

  def then_i_see_the_results_for_wales
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.devolved_nations.wales.guidance.label"))
  end

  def then_i_see_an_invalid_postcode_error_message
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error"))
  end

  def then_i_see_the_no_information_page
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.no_information.heading"))
  end

  def then_i_see_the_results_page_for_level_one_with_changing_restriction_levels
    assert page.has_text?(@area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_one.changing_alert_level", area: @area))
  end

  def then_i_see_an_out_of_date_warning
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.out_of_date_warning"))
  end

  def then_i_do_not_see_an_out_of_date_warning
    assert_not page.has_text?(I18n.t("coronavirus_local_restrictions.out_of_date_warning"))
  end

  def and_there_is_metadata
    assert page.has_css?("meta[property='og:title'][content='#{I18n.t('coronavirus_local_restrictions.lookup.meta_title')}']", visible: false)
    assert page.has_css?("meta[name='description'][content='#{I18n.t('coronavirus_local_restrictions.lookup.meta_description')}']", visible: false)
    assert page.has_css?("link[rel='canonical'][href='http://www.example.com/find-coronavirus-local-restrictions']", visible: false)
  end
end
