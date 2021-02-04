require "test_helper"
require "gds_api/test_helpers/mapit"

describe PostcodeLocalRestrictionSearch do
  include GdsApi::TestHelpers::Mapit

  before do
    stub_mapit_has_a_postcode_and_areas("E1 8QS", [], [{
      "gss" => "E09000030",
      "name" => "London Borough of Tower Hamlets",
      "type" => "LBO",
      "country_name" => "England",
    }])
  end

  describe "UK_POSTCODE_PATTERN" do
    let(:pattern) { described_class::UK_POSTCODE_PATTERN }

    it "matches valid postcodes" do
      assert_match pattern, "sw1a 2aa"
      assert_match pattern, "LS11UR"
      assert_match pattern, "BT15 3JX"
    end

    it "doesn't match invalid postcodes" do
      assert_no_match pattern, "sw1a"
      assert_no_match pattern, "LS 11UR"
      assert_no_match pattern, " BT15 3JX "
    end

    it "doesn't match quirky non-geographical postcodes" do
      assert_no_match pattern, "GIR 0AA"
    end
  end

  describe "#sanitised_postcode" do
    it "returns the postcode as a formatted UK postcode" do
      instance = described_class.new("e18qs")
      assert_equal "E1 8QS", instance.sanitised_postcode
    end

    it "accepts postcodes that have non-alphanumeric characters" do
      instance = described_class.new("E1!@£$%^&*8QS")
      assert_equal "E1 8QS", instance.sanitised_postcode
    end

    it "accepts and fixes common character errors in postcodes" do
      instance = described_class.new("EI 8QS")
      assert_equal "E1 8QS", instance.sanitised_postcode
    end
  end

  describe "#error_code" do
    it "returns nil when there isn't an error" do
      instance = described_class.new("E1 8QS")
      assert_nil instance.error_code
    end

    it "returns 'postcodeLeftBlank' for a blank postcode" do
      instance = described_class.new("")
      assert_equal "postcodeLeftBlank", instance.error_code
    end

    it "returns 'postcodeLeftBlankSanitized' for an unsalvagable postcode" do
      instance = described_class.new("!@£$%^&*(")
      assert_equal "postcodeLeftBlankSanitized", instance.error_code
    end

    it "returns 'invalidPostcodeFormat' for a non postcode" do
      instance = described_class.new("not-a-postcode")
      assert_equal "invalidPostcodeFormat", instance.error_code
    end

    it "returns 'fullPostcodeNoMapitMatch' when mapit doesn't know the postcode" do
      stub_mapit_does_not_have_a_postcode("E1 8QS")
      instance = described_class.new("E1 8QS")
      assert_equal "fullPostcodeNoMapitMatch", instance.error_code
    end

    it "returns 'fullPostcodeNoMapitValidation' when mapit doesn't like the postcode" do
      stub_mapit_does_not_have_a_bad_postcode("E1 8QS")
      instance = described_class.new("E1 8QS")
      assert_equal "fullPostcodeNoMapitValidation", instance.error_code
    end
  end

  describe "#invalid_postcode?" do
    it "returns true for an invalid postcode scenarios" do
      assert described_class.new("not-a-postcode").invalid_postcode?
    end

    it "returns false when the input is a valid postcode" do
      assert_not described_class.new("E1 8QS").invalid_postcode?
    end

    it "returns false if mapit doesn't know about the postcode" do
      stub_mapit_does_not_have_a_postcode("E1 8QS")

      assert_not described_class.new("E1 8QS").invalid_postcode?
    end

    it "returns true for missing postcode scenarios" do
      assert described_class.new("").invalid_postcode?
    end
  end

  describe "#no_restriction?" do
    it "returns true when an english postcode has no restriction data" do
      LocalRestriction.stubs(:find).with("E09000030").returns(nil)

      assert described_class.new("E1 8QS").no_restriction?
    end

    it "returns false when an english postcode has a restriction" do
      restriction = LocalRestriction.new("E09000030", { "name" => "London Borough of Tower Hamlets" })
      LocalRestriction.stubs(:find).with("E09000030").returns(restriction)

      assert_not described_class.new("E1 8QS").no_restriction?
    end

    it "returns false for a develolved nation postcode" do
      stub_mapit_has_a_postcode_and_areas("EH7 4EW", [], [{
        "gss" => "S12000036",
        "name" => "Edinburgh",
        "type" => "LBO",
        "country_name" => "Scotland",
      }])

      assert_not described_class.new("EH7 4EW").no_restriction?
    end
  end

  describe "#local_restriction" do
    it "matches a postcode to its local restriction" do
      stub_mapit_has_a_postcode_and_areas("SW1A 2AA", [], [
        {
          "gss" => "E32000014",
          "name" => "West Central",
          "type" => "LAC",
          "country_name" => "England",
        },
        {
          "gss" => "E09000033",
          "name" => "Westminster City Council",
          "type" => "LBO",
          "country_name" => "England",
        },
      ])

      LocalRestriction.stubs(:find).with("E32000014").returns(nil)
      restriction = LocalRestriction.new("E09000033", { "name" => "Westminster City Council" })
      LocalRestriction.stubs(:find).with("E09000033").returns(restriction)

      assert_equal restriction, described_class.new("SW1A 2AA").local_restriction
    end

    it "returns nil when the area doesn't have a local restriction" do
      stub_mapit_has_a_postcode_and_areas("SW1A 2AA", [], [
        {
          "gss" => "E09000033",
          "name" => "Westminster City Council",
          "type" => "LBO",
          "country_name" => "England",
        },
      ])
      LocalRestriction.stubs(:find).with("E09000033").returns(nil)

      assert_nil described_class.new("SW1A 2AA").local_restriction
    end

    it "returns nil when the postcode has an error" do
      assert_nil described_class.new("not-a-postcode").local_restriction
    end

    it "returns nil when Mapit has no information for the location" do
      stub_mapit_has_a_postcode_and_areas("SW1A 2AA", [], [])

      assert_nil described_class.new("SW1A 2AA").local_restriction
    end
  end
end
