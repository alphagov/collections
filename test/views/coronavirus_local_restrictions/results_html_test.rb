require "test_helper"
require "gds_api/test_helpers/mapit"
require_relative "../../support/coronavirus_local_restrictions_helpers"

module CoronavirusLocalRestrictions
  class CoronavirusLocalRestrictions::ResultsHtmlTest < ActionView::TestCase
    include GdsApi::TestHelpers::Mapit
    include CoronavirusLocalRestrictionsHelpers
    helper Rails.application.helpers

    describe "current restrictions" do
      test "rendering tier 4 results for a postcode in tier 4" do
        render_tier_results(current_alert_level: 4)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_pretext")
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_tier_label")
        assert_includes rendered, area
      end

      test "rendering tier 3 results for a postcode in tier 3" do
        render_tier_results(current_alert_level: 3)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_three.heading_pretext")
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_three.heading_tier_label")
        assert_includes rendered, area
      end

      test "rendering tier 2 results for a postcode in tier 2" do
        render_tier_results(current_alert_level: 2)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_pretext")
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_tier_label")
        assert_includes rendered, area
      end

      test "rendering tier 1 results for a postcode in tier 1" do
        render_tier_results(current_alert_level: 1)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_one.heading_pretext")
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_one.heading_tier_label")
        assert_includes rendered, area
      end

      test "rendering postcode match if the postcode is correct except for a special character" do
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
    end

    describe "devolved nations" do
      test "rendering results for a Welsh postcode" do
        postcode = "LL11 0BY"
        country_name = "Wales"

        render_devolved_nation_guidance(postcode, country_name)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.devolved_nations.wales.guidance.label")
      end

      test "rendering results for a Scottish postcode" do
        postcode = "G20 9SH"
        country_name = "Scotland"

        render_devolved_nation_guidance(postcode, country_name)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.devolved_nations.scotland.guidance.label")
      end

      test "rendering results for a Northern Irish postcode" do
        postcode = "BT48 7PX"
        country_name = "Northern Ireland"

        render_devolved_nation_guidance(postcode, country_name)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.devolved_nations.northern_ireland.guidance.label")
      end
    end

    describe "future restrictions" do
      test "rendering restrictions changing from level one to level two" do
        render_tier_results(current_alert_level: 1, future_alert_level: 2)
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_one.changing_alert_level", area: area)
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.future.level_two.alert_level", area: area)
      end

      test "rendering restrictions changing from level two to level three" do
        render_tier_results(current_alert_level: 2, future_alert_level: 3)
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.changing_alert_level", area: area)
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.future.level_three.alert_level", area: area)
      end

      test "rendering restrictions changing from level three to level four" do
        render_tier_results(current_alert_level: 3, future_alert_level: 4)
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_three.changing_alert_level", area: area)
        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.future.level_four.alert_level", area: area)
      end
    end

    describe "out of date restrictions" do
      test "rendering an out of date warning on the tier one page" do
        render_tier_results_out_of_date_warning(current_alert_level: 1)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
      end

      test "rendering an out of date warning on the tier two page" do
        render_tier_results_out_of_date_warning(current_alert_level: 2)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
      end

      test "rendering an out of date warning on the tier three page" do
        render_tier_results_out_of_date_warning(current_alert_level: 3)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
      end

      test "rendering an out of date warning on the tier four page" do
        render_tier_results_out_of_date_warning(current_alert_level: 4)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.out_of_date_warning")
      end
    end

    def render_tier_results(current_alert_level: nil, future_alert_level: nil)
      postcode = "E1 8QS"
      @search = PostcodeLocalRestrictionSearch.new(postcode)
      stub_local_restriction(postcode: postcode, name: area, current_alert_level: current_alert_level, future_alert_level: future_alert_level)

      view.stubs(:out_of_date?).returns(false)

      render template: "coronavirus_local_restrictions/results"
    end

    def render_devolved_nation_guidance(postcode, country_name)
      stub_local_restriction(postcode: postcode, country_name: country_name)

      @search = PostcodeLocalRestrictionSearch.new(postcode)

      view.stubs(:out_of_date?).returns(false)

      render template: "coronavirus_local_restrictions/results"
    end

    def render_tier_results_out_of_date_warning(current_alert_level: nil, future_alert_level: nil)
      postcode = "E1 8QS"
      @search = PostcodeLocalRestrictionSearch.new(postcode)
      stub_local_restriction(postcode: postcode, name: area, current_alert_level: current_alert_level, future_alert_level: future_alert_level)

      view.stubs(:out_of_date?).returns(true)

      render template: "coronavirus_local_restrictions/results"
    end

    def area
      "Tattooine"
    end
  end
end
