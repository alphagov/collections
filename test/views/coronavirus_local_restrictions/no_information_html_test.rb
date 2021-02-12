require "test_helper"
require "gds_api/test_helpers/mapit"
require_relative "../../support/coronavirus_local_restrictions_helpers"

module CoronavirusLocalRestrictions
  class CoronavirusLocalRestrictions::NoInformationHtmlTest < ActionView::TestCase
    include GdsApi::TestHelpers::Mapit
    include CoronavirusLocalRestrictionsHelpers
    helper Rails.application.helpers

    describe "current restrictions" do
      test "rendering no tier information for a postcode without a local restriction" do
        stub_no_local_restriction(postcode: "E1 8QS")

        render_no_information_page

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.no_information.heading")
      end
    end

    describe "no data returned from Mapit" do
      test "rendering no information found if the postcode is in a valid format, but there is no data" do
        postcode = "IM1 1AF"
        mapit_endpoint = Plek.current.find("mapit")

        stub_request(:get, "#{mapit_endpoint}/postcode/" + postcode.tr(" ", "+") + ".json")
            .to_return(body: { "postcode" => postcode.to_s, "areas" => {} }.to_json, status: 200)

        render_no_information_page

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.results.no_information.heading")
      end
    end

    def render_no_information_page
      @search = PostcodeLocalRestrictionSearch.new("E1 8QS")

      view.stubs(:out_of_date?).returns(false)

      render template: "coronavirus_local_restrictions/no_information"
    end
  end
end
