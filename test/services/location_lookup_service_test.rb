require "test_helper"
require "gds_api/test_helpers/mapit"

describe LocationLookupService do
  include GdsApi::TestHelpers::Mapit

  describe "#data" do
    it "returns location data" do
      postcode = "E18QS"
      areas = [
        {
          "ons" => "01",
          "gss" => "E01000123",
          "govuk_slug" => "test-one",
          "name" => "Coruscant Planetary Council",
          "type" => "LBO",
          "country_name" => "England",
        },
        {
          "ons" => "02",
          "gss" => "E02000456",
          "govuk_slug" => "test-two",
          "name" => "Galactic Empire",
          "type" => "GLA",
          "country_name" => "England",
        },
      ]
      stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

      data = described_class.new(postcode).data

      assert_equal(2, data.size)
      assert_instance_of(MapitPostcodeResponse, data.first)
      assert_equal("E01000123", data.first.gss)

      assert_instance_of(MapitPostcodeResponse, data.second)
      assert_equal("E02000456", data.second.gss)
    end

    it "only returns locations with a gss code" do
      postcode = "E18QS"
      areas = [
        {
          "ons" => "01",
          "gss" => "E01000123",
          "govuk_slug" => "test-one",
          "name" => "Coruscant Planetary Council",
          "type" => "LBO",
          "country_name" => "England",
        },
        {
          "govuk_slug" => "test-two",
          "name" => "Galactic Empire",
          "type" => "GLA",
          "country_name" => "England",
        },
      ]
      stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

      data = described_class.new(postcode).data

      assert_equal(1, data.size)
      assert_instance_of(MapitPostcodeResponse, data.first)
      assert_equal("E01000123", data.first.gss)
    end

    it "returns an error if the postcode isn't found" do
      postcode = "E18QS"
      stub_mapit_does_not_have_a_postcode(postcode)

      assert_equal([], described_class.new(postcode).data)
      assert_not_nil(described_class.new(postcode).error)
      assert(described_class.new(postcode).postcode_not_found?)
    end

    it "returns an error if the postcode is not valid" do
      invalid_postcode = "hello"
      stub_mapit_does_not_have_a_bad_postcode(invalid_postcode)

      assert_equal([], described_class.new(invalid_postcode).data)
      assert_match(invalid_postcode, described_class.new(invalid_postcode).error[:message])
      assert(described_class.new(invalid_postcode).invalid_postcode?)
    end

    it "returns the lowest tier area code" do
      postcode = "E18QS"
      areas = [
        {
          "ons" => "01",
          "gss" => "E01000123",
          "govuk_slug" => "test-one",
          "name" => "Coruscant Planetary Council",
          "type" => "LBO",
          "country_name" => "England",
        },
        {
          "ons" => "02",
          "gss" => "E02000456",
          "govuk_slug" => "test-two",
          "name" => "Galactic Empire",
          "type" => "GLA",
          "country_name" => "England",
        },
      ]
      stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

      assert_equal("Coruscant Planetary Council", described_class.new(postcode).lower_tier_area_name)
    end

    it "returns no information if the postcode is in a valid format but there is no data" do
      postcode = "IM11AF"
      MAPIT_ENDPOINT = Plek.current.find("mapit")

      stub_request(:get, "#{MAPIT_ENDPOINT}/postcode/" + postcode.tr(" ", "+") + ".json")
          .to_return(body: { "postcode" => postcode.to_s, "areas" => {} }.to_json, status: 200)

      assert(described_class.new(postcode).no_information?)
    end
  end
end
