require "test_helper"
require "gds_api/test_helpers/mapit"
require_relative "../../test/support/coronavirus_helper"

class CoronavirusLocalRestrictionTest < ActionView::TestCase
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentItemHelpers
  helper Rails.application.helpers

  describe "current restrictions" do
    test "renders postcode match tier 4" do
      render_tier_results(current_alert_level: 4)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_pretext")
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_tier_label")
      assert_includes rendered, area
    end

    test "renders postcode match tier 3" do
      render_tier_results(current_alert_level: 3)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_pretext")
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_three.heading_tier_label")
      assert_includes rendered, area
    end

    test "renders postcode match tier 2" do
      render_tier_results(current_alert_level: 2)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_pretext")
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_tier_label")
      assert_includes rendered, area
    end

    test "renders postcode match tier 1" do
      render_tier_results(current_alert_level: 1)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_pretext")
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_one.heading_tier_label")
      assert_includes rendered, area
    end

    test "renders postcode match if the postcode is correct except for a special character" do
      area = "Coruscant Planetary Council"
      postcode = ".E1 8QS"

      stub_local_restriction(postcode: "E1 8QS", name: area, current_alert_level: 2)

      @search = PostcodeLocalRestrictionSearch.new(postcode)

      view.stubs(:out_of_date?).returns(false)

      render template: "coronavirus_local_restrictions/results"

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_pretext")
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_tier_label")
      assert_includes rendered, area
    end

    test "renders no tier information" do
      stub_no_local_restriction(postcode: postcode, name: @area)

      render_no_information_page

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.no_information.heading")
    end
  end

  describe "devolved_nations" do
    test "renders guidance for Wales" do
      postcode = "LL11 0BY"
      country_name = "Wales"

      render_devolved_nation_guidance(postcode, country_name)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.devolved_nations.wales.guidance.label")
    end

    test "renders guidance for Scotland" do
      postcode = "G20 9SH"
      country_name = "Scotland"

      render_devolved_nation_guidance(postcode, country_name)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.devolved_nations.scotland.guidance.label")
    end
  end

  test "renders guidance for Northern Ireland" do
    postcode = "BT48 7PX"
    country_name = "Northern Ireland"

    render_devolved_nation_guidance(postcode, country_name)

    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.devolved_nations.northern_ireland.guidance.label")
  end

  describe "errors" do
    test "renders error when invalid postcode is entered" do
      postcode = "hello"

      stub_local_restriction(postcode: postcode)

      render_show_page(postcode)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error")
    end

    test "renders error when postcode does not exist" do
      postcode = "XM4 5HQ"

      stub_mapit_does_not_have_a_postcode(postcode)

      render_show_page(postcode)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.errors.postcode_not_found.input_error")
    end
  end

  describe "no data returned from mapit" do
    test "renders no information found if the postcode is in a valid format, but there is no data" do
      postcode = "IM1 1AF"
      mapit_endpoint = Plek.current.find("mapit")

      stub_request(:get, "#{mapit_endpoint}/postcode/" + postcode.tr(" ", "+") + ".json")
          .to_return(body: { "postcode" => postcode.to_s, "areas" => {} }.to_json, status: 200)

      render_no_information_page

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.no_information.heading")
    end
  end

  describe "future restrictions" do
    test "renders restrictions changing from level one to level two" do
      render_tier_results(current_alert_level: 1, future_alert_level: 2)
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_one.changing_alert_level", area: area)
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.future.level_two.alert_level", area: area)
    end

    test "renders restrictions changing from level two to level three" do
      render_tier_results(current_alert_level: 2, future_alert_level: 3)
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.changing_alert_level", area: area)
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.future.level_three.alert_level", area: area)
    end

    test "renders restrictions changing from level three to level four" do
      render_tier_results(current_alert_level: 3, future_alert_level: 4)
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_three.changing_alert_level", area: area)
      assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.future.level_four.alert_level", area: area)
    end
  end

  describe "when the restrictions are out of date" do
    test "renders an out of date warning on the tier one page" do
      render_tier_results_out_of_date_warning(current_alert_level: 1)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
    end

    test "renders an out of date warning on the tier two page" do
      render_tier_results_out_of_date_warning(current_alert_level: 2)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
    end

    test "renders an out of date warning on the tier three page" do
      render_tier_results_out_of_date_warning(current_alert_level: 3)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
    end

    test "renders an out of date warning on the tier four page" do
      render_tier_results_out_of_date_warning(current_alert_level: 4)

      assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
    end
  end

  def area
    "Tattooine"
  end

  def postcode
    "E1 8QS"
  end

  def render_devolved_nation_guidance(postcode, country_name)
    stub_local_restriction(postcode: postcode, country_name: country_name)

    @search = PostcodeLocalRestrictionSearch.new(postcode)

    view.stubs(:out_of_date?).returns(false)

    render template: "coronavirus_local_restrictions/results"
  end

  def render_tier_results(current_alert_level: nil, future_alert_level: nil)
    @search = PostcodeLocalRestrictionSearch.new(postcode)
    stub_local_restriction(postcode: postcode, name: area, current_alert_level: current_alert_level, future_alert_level: future_alert_level)

    view.stubs(:out_of_date?).returns(false)

    render template: "coronavirus_local_restrictions/results"
  end

  def render_tier_results_out_of_date_warning(current_alert_level: nil, future_alert_level: nil)
    @search = PostcodeLocalRestrictionSearch.new(postcode)
    stub_local_restriction(postcode: postcode, name: area, current_alert_level: current_alert_level, future_alert_level: future_alert_level)

    view.stubs(:out_of_date?).returns(true)

    render template: "coronavirus_local_restrictions/results"
  end

  def render_show_page(postcode)
    @search = PostcodeLocalRestrictionSearch.new(postcode)
    @content_item = coronavirus_content_item

    view.stubs(:out_of_date?).returns(false)

    render template: "coronavirus_local_restrictions/show"
  end

  def render_no_information_page
    @search = PostcodeLocalRestrictionSearch.new(postcode)

    view.stubs(:out_of_date?).returns(false)

    render template: "coronavirus_local_restrictions/no_information"
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
