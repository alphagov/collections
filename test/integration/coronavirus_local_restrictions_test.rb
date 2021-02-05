require "integration_test_helper"
require "gds_api/test_helpers/mapit"

class CoronavirusLocalRestrictionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentStore

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
    it "errors gracefully if you don't enter a postcode" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      when_i_enter_an_invalid_postcode
      then_i_click_on_find
      then_i_can_see_the_postcode_lookup_form
      then_i_see_an_invalid_postcode_error_message
    end

    it "errors gracefully if the postcode is invalid" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      when_i_enter_an_invalid_postcode
      then_i_click_on_find
      then_i_can_see_the_invalid_postcode_in_the_form
      then_i_see_an_invalid_postcode_error_message
    end

    it "errors gracefully if the postcode doesn't exist" do
      given_i_am_on_the_local_restrictions_page
      then_i_can_see_the_postcode_lookup_form
      when_i_enter_a_postcode_that_does_not_exist
      then_i_click_on_find
      then_i_can_see_the_postcode_lookup_form
      then_i_see_a_postcode_not_found_error_message
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

    it "displays restrictions changing from level three to level four" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_with_a_future_level_four_restriction
      then_i_click_on_find
      then_i_see_the_results_page_for_level_three_with_changing_restriction_levels
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

    it "displays an out of date warning on the tier two page" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_in_tier_two
      then_i_click_on_find
      then_i_see_an_out_of_date_warning
    end

    it "displays an out of date warning on the tier three page" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_in_tier_three
      then_i_click_on_find
      then_i_see_an_out_of_date_warning
    end

    it "displays an out of date warning on the tier four page" do
      given_i_am_on_the_local_restrictions_page
      then_i_enter_a_valid_english_postcode_in_tier_four
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

  def then_i_enter_a_valid_english_postcode_with_a_future_level_three_restriction
    @area = "Alderaan"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: postcode,
                           name: @area,
                           current_alert_level: 2,
                           future_alert_level: 3)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_english_postcode_with_a_future_level_four_restriction
    @area = "Kashyyyk"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: postcode,
                           name: @area,
                           current_alert_level: 3,
                           future_alert_level: 4)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_english_postcode_with_an_extra_special_character
    @area = "Coruscant Planetary Council"
    stub_local_restriction(postcode: "E1 8QS", name: @area, current_alert_level: 2)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: ".e18qs"
  end

  def then_i_enter_a_valid_english_postcode_in_tier_one
    @area = "Coruscant Planetary Council"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: "E1 8QS", name: @area, current_alert_level: 1)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_english_postcode_in_tier_two
    @area = "Coruscant Planetary Council"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: postcode, name: @area, current_alert_level: 2)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_english_postcode_in_tier_three
    @area = "Mandalore"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: postcode, name: @area, current_alert_level: 3)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_english_postcode_in_tier_four
    @area = "Anoat"
    postcode = "E1 8QS"
    stub_local_restriction(postcode: postcode, name: @area, current_alert_level: 4)

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_welsh_postcode
    postcode = "LL11 0BY"
    stub_local_restriction(postcode: postcode, country_name: "Wales")

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_scottish_postcode
    postcode = "G20 9SH"
    stub_local_restriction(postcode: postcode, country_name: "Scotland")

    fill_in I18n.t("coronavirus_local_restrictions.lookup.input_label"), with: postcode
  end

  def then_i_enter_a_valid_northern_ireland_postcode
    postcode = "BT48 7PX"
    stub_local_restriction(postcode: postcode, country_name: "Northern Ireland")

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

  def when_i_enter_a_postcode_that_does_not_exist
    postcode = "XM4 5HQ"
    stub_mapit_does_not_have_a_postcode(postcode)

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

  def then_i_see_the_results_page_for_level_one
    heading = "#{I18n.t('coronavirus_local_restrictions.results.level_one.heading_pretext')} #{I18n.t('coronavirus_local_restrictions.results.level_one.heading_tier_label')}"
    assert page.has_text?(@area)
    assert page.has_text?(heading)
  end

  def then_i_see_the_results_page_for_level_two
    heading = "#{I18n.t('coronavirus_local_restrictions.results.level_two.heading_pretext')} #{I18n.t('coronavirus_local_restrictions.results.level_two.heading_tier_label')}"
    assert page.has_text?(@area)
    assert page.has_text?(heading)
  end

  def then_i_see_the_results_for_wales
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.devolved_nations.wales.guidance.label"))
  end

  def then_i_see_the_results_for_scotland
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.devolved_nations.scotland.guidance.label"))
  end

  def then_i_see_the_results_for_northern_ireland
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.devolved_nations.northern_ireland.guidance.label"))
  end

  def then_i_see_a_postcode_not_found_error_message
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.errors.postcode_not_found.input_error"))
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

  def then_i_see_the_results_page_for_level_two_with_changing_restriction_levels
    assert page.has_text?(@area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_two.changing_alert_level", area: @area))
  end

  def then_i_see_the_results_page_for_level_three_with_changing_restriction_levels
    assert page.has_text?(@area)
    assert page.has_text?(I18n.t("coronavirus_local_restrictions.results.level_three.changing_alert_level", area: @area))
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

  def stub_local_restriction(postcode:,
                             name: "Tatooine",
                             gss: SecureRandom.alphanumeric(10),
                             country_name: "England",
                             current_alert_level: nil,
                             future_alert_level: nil)
    areas = [
      {
        "gss" => gss,
        "name" => name,
        "type" => "LBO",
        "country_name" => country_name,
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    current_restriction = if current_alert_level
                            { "alert_level" => current_alert_level,
                              "start_date" => 1.week.ago.to_date,
                              "start_time" => "10:00" }
                          end

    future_restriction = if future_alert_level
                           { "alert_level" => future_alert_level,
                             "start_date" => 1.week.from_now.to_date,
                             "start_time" => "10:00" }
                         end

    local_restriction = LocalRestriction.new(gss, {
      "name" => name,
      "restrictions" => [current_restriction, future_restriction].compact,
    })
    LocalRestriction.stubs(:find).with(gss).returns(local_restriction)
  end

  def stub_no_local_restriction(
    postcode:,
    name: "Tatooine",
    gss: SecureRandom.alphanumeric(10),
    country_name: "England"
  )
    areas = [
      {
        "gss" => gss,
        "name" => name,
        "type" => "LBO",
        "country_name" => country_name,
      },
    ]
    stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

    LocalRestriction.stubs(:find).with(gss).returns(nil)
  end
end
