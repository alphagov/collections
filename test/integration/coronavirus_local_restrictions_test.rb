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

  it "displays the right restrictions if the postcode is correct except for a special character" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    then_i_enter_a_valid_english_postcode_with_an_extra_special_character
    then_i_click_on_find
    then_i_see_the_results_page_for_level_two_with_future_level_three_restrictions
  end

  describe "future restrictions" do
    before do
      travel_to Time.zone.local(2020, 10, 12, 20, 10, 10)
    end

    after do
      travel_back
    end

    it "displays future restrictions" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_with_a_future_restriction
      then_i_click_on_find
      then_i_see_the_results_page_for_level_two_with_future_level_three_restrictions
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

  def then_i_enter_a_valid_english_postcode
    postcode = "E1 8QS"
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

  def then_i_enter_a_valid_english_postcode_with_a_future_restriction
    postcode = "E1 8QS"
    areas = [
      {
        "gss" => "E08000001",
        "name" => "Coruscant Planetary Council",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)
    LocalRestriction.any_instance.stubs(:file_name).returns("test/fixtures/local-restrictions.yaml")

    fill_in "Enter your postcode", with: postcode
  end

  def then_i_enter_a_valid_english_postcode_with_an_extra_special_character
    areas = [
      {
        "gss" => "E08000001",
        "name" => "Coruscant Planetary Council",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas("E1 8QS", [], areas)
    LocalRestriction.any_instance.stubs(:file_name).returns("test/fixtures/local-restrictions.yaml")

    fill_in "Enter your postcode", with: ".e18qs"
  end

  def then_i_enter_a_valid_english_postcode_in_tier_two
    postcode = "E1 8QS"
    areas = [
      {
        "gss" => "E09000030",
        "name" => "London Borough of Tower Hamlets",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter your postcode", with: postcode
  end

  def then_i_enter_a_valid_welsh_postcode
    postcode = "LL11 0BY"
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
    postcode = "IM1 1AF"
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
    assert page.has_text?("London Borough of Tower Hamlets")
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

  def then_i_see_the_results_page_for_level_two_with_future_level_three_restrictions
    date = "2021-10-12".to_date.strftime("%-d %B")

    assert page.has_text?("Tatooine")
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_two.changing_alert_level"))
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.future.level_three.alert_level", date: date))
  end
end
