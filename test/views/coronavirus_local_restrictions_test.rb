require "test_helper"
require "gds_api/test_helpers/mapit"
require_relative "../../test/support/coronavirus_helper"

class CoronavirusLocalRestrictionTest < ActionView::TestCase
  CORONAVIRUS_PATH = "/coronavirus".freeze
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentItemHelpers
  helper Rails.application.helpers

  test "renders postcode match tier 4" do
    postcode = "E1 8QS"
    area = "Tattooine"

    @search = PostcodeLocalRestrictionSearch.new(postcode)
    stub_local_restriction(postcode: postcode, name: area, current_alert_level: 4)

    view.stubs(:out_of_date?).returns(false)

    render template: "coronavirus_local_restrictions/results"

    assert_select ".coronavirus-local-restriction__heading-tier-label", text: "Tier 4: Stay at Home"
    assert_select ".govuk-body", text: "We've matched the postcode #{postcode} to #{area}."
  end

  test "renders postcode match tier 3" do
    postcode = "E1 8QS"
    area = "Tattooine"

    @search = PostcodeLocalRestrictionSearch.new(postcode)
    stub_local_restriction(postcode: postcode, name: area, current_alert_level: 3)

    view.stubs(:out_of_date?).returns(false)
    render template: "coronavirus_local_restrictions/results"

    assert_select ".coronavirus-local-restriction__heading-tier-label", text: "Tier 3: Very High alert"
    assert_select ".govuk-body", text: "We've matched the postcode #{postcode} to #{area}."
  end

   test "renders postcode match devolved nations" do
     postcode = "LL11 0BY"
     stub_local_restriction(postcode: postcode, country_name: "Wales")

     @search = PostcodeLocalRestrictionSearch.new(postcode)

     view.stubs(:out_of_date?).returns(false)

     render template: "coronavirus_local_restrictions/results"
     assert_select ".govuk-body", text: "The rules are different in Wales."
   end

   test "renders no tier information" do
     @area = "Tattooine"
     postcode = "E1 8QS"
     stub_no_local_restriction(postcode: postcode, name: @area)

     @search = PostcodeLocalRestrictionSearch.new(postcode)

     view.stubs(:out_of_date?).returns(false)

     render template: "coronavirus_local_restrictions/no_information"

     assert_select ".govuk-body"

     # assert_select ".gem-c-title__text", text: "There is no information about the restrictions in this area"
   end

  test "renders error when invalid postcode is entered" do
    postcode = "hello"

    @search = PostcodeLocalRestrictionSearch.new(postcode)

    stub_local_restriction(postcode: postcode)
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item)

    view.stubs(:out_of_date?).returns(false)
    view.stubs(:simple_smart_answer?).returns(false)

    render template: "coronavirus_local_restrictions/show"
    render partial: "coronavirus_local_restrictions/meta_tags"
    render partial: 'govuk_publishing_components/components/contextual_breadcrumbs', locals: { content_item: coronavirus_content_item }
    render partial: 'govuk_publishing_components/components/contextual_footer', locals: { content_item: coronavirus_content_item }

    # This won't work as the last rendered partial doesn't contain the error summary...
    assert_select ".govuk-error-summary__body"
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
