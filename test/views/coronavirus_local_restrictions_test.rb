require "test_helper"
require "gds_api/test_helpers/mapit"

class CoronavirusLocalRestrictionTest < ActionView::TestCase
  include GdsApi::TestHelpers::Mapit
  helper Rails.application.helpers

  test "renders postcode match" do
    postcode = "E1 8QS"

    @search = PostcodeLocalRestrictionSearch.new(postcode)
    stub_local_restriction(postcode: postcode, name: "Tattooine", current_alert_level: 1)

    view.stubs(:out_of_date?).returns(false)
    render template: "coronavirus_local_restrictions/results"

    assert_select ".govuk-body"
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
