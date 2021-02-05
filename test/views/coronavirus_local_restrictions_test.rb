require "test_helper"
require "gds_api/test_helpers/mapit"

class CoronavirusLocalRestrictionTest < ActionView::TestCase
  include GdsApi::TestHelpers::Mapit

  test "renders postcode match tier 4" do
    render_tier_results(4)

    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_pretext")
    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_tier_label")
    assert_includes rendered, area
  end

  test "renders postcode match tier 3" do
    render_tier_results(3)

    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_four.heading_pretext")
    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_three.heading_tier_label")
    assert_includes rendered, area
  end

  test "renders postcode match tier 2" do
    render_tier_results(2)

    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_pretext")
    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_tier_label")
    assert_includes rendered, area
  end

  test "renders postcode match tier 1" do
    render_tier_results(1)

    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_two.heading_pretext")
    assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.level_one.heading_tier_label")
    assert_includes rendered, area
  end

  def area
    "Tattooine"
  end

  def postcode
    "E1 8QS"
  end

  def render_tier_results(tier)
    @search = PostcodeLocalRestrictionSearch.new(postcode)
    stub_local_restriction(postcode: postcode, name: area, current_alert_level: tier)

    view.stubs(:out_of_date?).returns(false)

    render template: "coronavirus_local_restrictions/results"
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
end
