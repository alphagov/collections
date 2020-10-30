require "integration_test_helper"
require "gds_api/test_helpers/mapit"

class CoronavirusLocalRestrictionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentStore

  before do
    LocalRestriction.any_instance.stubs(:file_name).returns("test/fixtures/local-restrictions.yaml")
  end

  describe "current restrictions" do
    it "displays the tier one restrictions" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_english_postcode
      then_i_click_on_find
      then_i_see_the_results_page_for_level_one
      then_i_see_details_of_national_restrictions
    end

    it "displays the tier two restrictions" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_english_postcode_in_tier_two
      then_i_click_on_find
      then_i_see_the_results_page_for_level_two
      then_i_see_details_of_national_restrictions
    end

    it "displays the tier three restrictions" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_english_postcode_in_tier_three
      then_i_click_on_find
      then_i_see_the_results_page_for_level_three
      then_i_see_details_of_national_restrictions
    end
  end

  describe "devolved_nations" do
    it "displays guidance for Wales" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_welsh_postcode
      then_i_click_on_find
      then_i_see_the_results_for_wales
    end

    it "displays guidance for Scotland" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_scottish_postcode
      then_i_click_on_find
      then_i_see_the_results_for_scotland
    end

    it "displays guidance for Northern Ireland" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_enter_a_valid_northern_ireland_postcode
      then_i_click_on_find
      then_i_see_the_results_for_northern_ireland
    end
  end

  describe "errors" do
    it "errors gracefully if you don't enter a postcode" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      then_i_click_on_find
      then_i_can_see_the_postcode_lookup_form
      then_i_see_a_no_postcode_error_message
    end

    it "errors gracefully if the postcode is invalid" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      when_i_enter_an_invalid_postcode
      then_i_click_on_find
      then_i_can_see_the_postcode_lookup_form
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

  it "displays the right restrictions if the postcode is correct except for a special character" do
    given_i_am_on_the_local_restrictions_page
    then_i_can_see_the_postcode_lookup_form
    then_i_enter_a_valid_english_postcode_with_an_extra_special_character
    then_i_click_on_find
    then_i_see_the_results_page_for_level_two
  end

  describe "future restrictions" do
    before do
      travel_to Time.zone.local(2020, 10, 11, 10, 10, 10)
    end

    after do
      travel_back
    end

    it "displays restrictions changing from level one to level two" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_with_a_future_level_two_restriction
      then_i_click_on_find
      then_i_see_the_results_page_for_level_one_with_changing_restriction_levels
    end

    it "displays restrictions changing from level two to level three" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_with_a_future_level_three_restriction
      then_i_click_on_find
      then_i_see_the_results_page_for_level_two_with_changing_restriction_levels
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
        "name" => "Tatooine",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter a full postcode", with: postcode
  end

  def then_i_enter_a_valid_english_postcode_with_a_future_level_two_restriction
    postcode = "E1 8QS"
    areas = [
      {
        "gss" => "E08000789",
        "name" => "Naboo",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter a full postcode", with: postcode
  end

  def then_i_enter_a_valid_english_postcode_with_a_future_level_three_restriction
    postcode = "E1 8QS"
    areas = [
      {
        "gss" => "E08001456",
        "name" => "Alderaan",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter a full postcode", with: postcode
  end

  def then_i_enter_a_valid_english_postcode_with_an_extra_special_character
    stub_mapit_has_a_postcode_and_areas("E1 8QS", [], [level_two_area])

    fill_in "Enter a full postcode", with: ".e18qs"
  end

  def then_i_enter_a_valid_english_postcode_in_tier_two
    postcode = "E1 8QS"
    stub_mapit_has_a_postcode_and_areas(postcode, [], [level_two_area])

    fill_in "Enter a full postcode", with: postcode
  end

  def then_i_enter_a_valid_english_postcode_in_tier_three
    postcode = "E1 8QS"
    areas = [
      {
        "gss" => "E08001234",
        "name" => "Mandalore",
        "type" => "LBO",
        "country_name" => "England",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter a full postcode", with: postcode
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

    fill_in "Enter a full postcode", with: postcode
  end

  def then_i_enter_a_valid_scottish_postcode
    postcode = "G20 9SH"
    areas = [
      {
        "gss" => "E01000123",
        "country_name" => "Scotland",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter a full postcode", with: postcode
  end

  def then_i_enter_a_valid_northern_ireland_postcode
    postcode = "BT48 7PX"
    areas = [
      {
        "gss" => "E01000123",
        "country_name" => "Northern Ireland",
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    fill_in "Enter a full postcode", with: postcode
  end

  def when_i_enter_a_valid_postcode_that_returns_no_results
    postcode = "IM1 1AF"
    mapit_endpoint = Plek.current.find("mapit")

    stub_request(:get, "#{mapit_endpoint}/postcode/" + postcode.tr(" ", "+") + ".json")
        .to_return(body: { "postcode" => postcode.to_s, "areas" => {} }.to_json, status: 200)

    fill_in "Enter a full postcode", with: postcode
  end

  def when_i_enter_an_invalid_postcode
    fill_in "Enter a full postcode", with: "Hello"
  end

  def then_i_click_on_find
    click_on "Find"
  end

  def then_i_see_the_results_page_for_level_one
    area = "Tatooine"
    assert page.has_text?(area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_one.alert_level", area: area))
  end

  def then_i_see_the_results_page_for_level_two
    area = "Coruscant Planetary Council"
    assert page.has_text?(area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_two.alert_level", area: area))
  end

  def then_i_see_the_results_page_for_level_three
    area = "Mandalore"
    assert page.has_text?(area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_three.alert_level", area: area))
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.travelling_between_levels.level_three.heading"))
  end

  def then_i_see_details_of_national_restrictions
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.national_restrictions.heading"))
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.national_restrictions.action_label"))
  end

  def then_i_see_the_results_for_wales
    assert page.has_text?("Welsh Government")
  end

  def then_i_see_the_results_for_scotland
    assert page.has_text?("Scottish Government")
  end

  def then_i_see_the_results_for_northern_ireland
    assert page.has_text?("Northern Ireland Government")
  end

  def then_i_see_a_no_postcode_error_message
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_message"))
  end

  def then_i_see_an_invalid_postcode_error_message
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_message"))
  end

  def then_i_see_the_no_information_page
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.no_information.heading"))
  end

  def then_i_see_the_results_page_for_level_one_with_changing_restriction_levels
    area = "Naboo"

    assert page.has_text?(area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_one.alert_level", area: area))
  end

  def then_i_see_the_results_page_for_level_two_with_changing_restriction_levels
    area = "Alderaan"

    assert page.has_text?(area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_two.alert_level", area: area))
  end

  def level_two_area
    {
      "gss" => "E08000456",
      "name" => "Coruscant Planetary Council",
      "type" => "LBO",
      "country_name" => "England",
    }
  end
end
