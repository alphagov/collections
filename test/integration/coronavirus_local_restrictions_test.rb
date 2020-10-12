require "integration_test_helper"
require "gds_api/test_helpers/mapit"

class CoronavirusLocalRestrictionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentStore

  it "displays the tier one restrictions" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    then_i_enter_a_valid_english_postcode
    then_i_click_on_find
    then_i_see_the_results_page_for_level_one
  end

  it "displays the tier two restrictions" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    then_i_enter_a_valid_english_postcode_in_tier_two
    then_i_click_on_find
    then_i_see_the_results_page_for_level_two
  end

  it "displays guidance for a devolved nation" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    then_i_enter_a_valid_welsh_postcode
    then_i_click_on_find
    then_i_see_the_results_for_wales
  end

  it "errors gracefully if you don't enter a postcode" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    then_i_click_on_find
    then_i_can_see_the_postcode_lookup_form
    then_i_see_an_error_message
  end

  it "displays no information found if the postcode is in a valid format, but there is no data" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    when_i_enter_a_valid_postcode_that_returns_no_results
    then_i_click_on_find
    then_i_see_the_no_information_page
  end

  def given_i_am_on_the_local_restrictions_page
    stub_content_store_has_item("/find-coronavirus-local-restrictions", {})

    visit find_coronavirus_local_restrictions_path
  end

  def then_i_can_see_the_postcode_lookup_form
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.lookup.title"))
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.lookup.input_label"))
  end

  def then_i_enter_a_valid_english_postcode
    postcode = "E18QS"
    areas = [
      {
        "gss" => "E01000123",
        "name" => "Coruscant Planetary Council",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter your postcode", with: postcode
  end

  def then_i_enter_a_valid_english_postcode_in_tier_two
    postcode = "M11AD"
    areas = [
      {
        "gss" => "E08000001",
        "name" => "Bolton",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter your postcode", with: postcode
  end

  def then_i_enter_a_valid_welsh_postcode
    postcode = "LL110BY"
    areas = [
      {
        "gss" => "E01000123",
        "country_name" => "Wales",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter your postcode", with: postcode
  end

  def when_i_enter_a_valid_postcode_that_returns_no_results
    postcode = "IM11AF"
    mapit_endpoint = Plek.current.find("mapit")

    stub_request(:get, "#{mapit_endpoint}/postcode/" + postcode.tr(" ", "+") + ".json")
        .to_return(body: { "postcode" => postcode.to_s, "areas" => {} }.to_json, status: 200)

    fill_in "Enter your postcode", with: postcode
  end

  def then_i_click_on_find
    click_on "Find"
  end

  def then_i_see_the_results_page_for_level_one
    assert page.has_text?("Coruscant Planetary Council")
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_one.heading"))
  end

  def then_i_see_the_results_page_for_level_two
    assert page.has_text?("Bolton")
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_two.alert_level"))
  end

  def then_i_see_the_results_for_wales
    assert page.has_text?("Welsh Government")
  end

  def then_i_see_an_error_message
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_message"))
  end

  def then_i_see_the_no_information_page
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.no_information.heading"))
  end
end
