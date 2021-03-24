require "gds_api/test_helpers/mapit"
module CoronavirusLocalRestrictionsHelpers
  include GdsApi::TestHelpers::Mapit
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
    allow(LocalRestriction)
    .to receive(:find)
    .with(gss)
    .and_return(local_restriction)
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

    allow(LocalRestriction)
    .to receive(:find)
    .with(gss)
    .and_return(nil)
  end
end
