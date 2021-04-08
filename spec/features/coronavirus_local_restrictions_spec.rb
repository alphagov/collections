require "integration_spec_helper"

RSpec.feature "Coronavirus local restrictions" do
  include CoronavirusLocalRestrictionsHelpers

  #   Consider writing view tests in test/views/coronavirus_local_restrictions/ to test rendering page information.
  #
  #   Integration tests should still be used to test users journeys. However, the number of these may be decreased
  #   by testing all possible outcomes using view tests and the general user journeys using integration tests.

  scenario "displays restrictions for an area with restrictions" do
    given_i_am_on_the_local_restrictions_page
    when_i_enter_a_valid_english_postcode_for_a_restriction_area
    then_i_click_on_find
    then_i_see_the_restriction_information
  end

  scenario "displays guidance for a devolved nation" do
    given_i_am_on_the_local_restrictions_page
    when_i_enter_a_postcode_for_a_devolved_nation_area
    then_i_click_on_find
    then_i_see_the_devolved_nation_guidance
  end

  scenario "displays no information for an area without tier information" do
    given_i_am_on_the_local_restrictions_page
    when_i_enter_a_valid_english_postcode_with_no_tier_information
    then_i_click_on_find
    then_i_see_the_no_information_page
  end

  describe "with javascript", js: true do
    before { WebMock.disable_net_connect!(allow_localhost: true) }
    after { Capybara.use_default_driver }

    scenario "normalises the submitted postcode" do
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
    expect(page).to have_text(@area)
    expect(page).to have_text(@postcode)
    expect(page.current_url).to match(/postcode=#{Regexp.escape(CGI.escape(@postcode))}/)
  end

  def then_i_see_the_restriction_information
    heading = "#{I18n.t('coronavirus_local_restrictions.results.level_one.heading_pretext')} #{I18n.t('coronavirus_local_restrictions.results.level_one.heading_tier_label')}"
    expect(page).to have_text(@area)
    expect(page).to have_text(heading)
  end

  def then_i_see_the_devolved_nation_guidance
    expect(page).to have_text(I18n.t("coronavirus_local_restrictions.results.devolved_nations.wales.guidance.label"))
  end

  def then_i_see_the_no_information_page
    expect(page).to have_text(I18n.t("coronavirus_local_restrictions.results.no_information.heading"))
  end
end
