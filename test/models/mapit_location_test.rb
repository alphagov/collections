require "test_helper"
require "gds_api/test_helpers/mapit"

describe MapitLocation do
  include GdsApi::TestHelpers::Mapit

  describe ".locations_for_postcode" do
    it "returns an array of MapitLocation object for areas with gss codes" do
      postcode = "E1 8QS"
      areas = [{ "gss" => "E01000123",
                 "name" => "Coruscant Planetary Council",
                 "type" => "LBO",
                 "country_name" => "England" },
               { "gss" => "E02000456",
                 "name" => "Galactic Empire",
                 "type" => "GLA",
                 "country_name" => "England" },
               { "name" => "Imperial Center",
                 "type" => "OMF",
                 "country_name" => "England" }]
      stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

      locations = described_class.locations_for_postcode("E1 8QS")
      assert 2, locations.length
      assert ["Coruscant Planetary Council", "Galactic Empire"], locations.map(&:name)
    end

    it "returns an empty array when no areas have gss codes" do
      postcode = "E1 8QS"
      areas = [{ "name" => "Imperial Center",
                 "type" => "OMF",
                 "country_name" => "England" }]
      stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

      assert_equal [], described_class.locations_for_postcode("E1 8QS")
    end

    it "raises a LocationNotFound error when Mapit doesn't have a postcode" do
      stub_mapit_does_not_have_a_postcode("E1 8QS")

      assert_raises described_class::LocationNotFound do
        described_class.locations_for_postcode("E1 8QS")
      end
    end

    it "raises a LocationInvalid error when Mapit returns a bad request response" do
      stub_mapit_does_not_have_a_bad_postcode("E1 8QS")

      assert_raises described_class::LocationInvalid do
        described_class.locations_for_postcode("E1 8QS")
      end
    end

    it "raises the GdsApi error when Mapit returns a different error response" do
      stub_request(:get, /mapit/).to_return(status: 500)

      assert_raises GdsApi::HTTPInternalServerError do
        described_class.locations_for_postcode("E1 8QS")
      end
    end
  end

  describe "#gss" do
    it "returns the area's gss code" do
      instance = described_class.new(OpenStruct.new(codes: { "gss" => "E01000123" }))
      assert_equal "E01000123", instance.gss
    end
  end
end
