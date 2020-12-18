require "test_helper"
require "gds_api/test_helpers/mapit"

describe CoronavirusRestrictionSearch do
  include GdsApi::TestHelpers::Mapit

  before do
    stub_mapit_has_a_postcode_and_areas("E1 8QS", [], [{
      "gss" => "E09000030",
      "name" => "London Borough of Tower Hamlets",
      "type" => "LBO",
      "country_name" => "England",
    }])

    stub_mapit_has_a_postcode_and_areas("EH1 1BE", [], [{
      "gss" => "S12000036",
      "name" => "City of Edinburgh Council",
      "type" => "UTA",
      "country_name" => "Scotland",
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

  describe "#blank_postcode?" do
    it "returns true for missing postcode scenarios" do
      assert described_class.new("").blank_postcode?
    end

    it "returns false when a postcode is input" do
      assert_not described_class.new("E1 8QS").blank_postcode?
    end
  end

  describe "#invalid_postcode?" do
    it "returns true for an invalid postcode scenarios" do
      assert described_class.new("not-a-postcode").invalid_postcode?
    end

    it "returns false when the input is a valid postcode" do
      assert_not described_class.new("E1 8QS").invalid_postcode?
    end
  end

  describe "#devolved_nation?" do
    it "returns true for a non-England UK nation" do
      assert described_class.new("EH1 1BE").devolved_nation?
    end

    it "returns false for a location within England" do
      assert_not described_class.new("E1 8QS").devolved_nation?
    end
  end

  describe "#england_result" do
    it "returns an EnglandResult object when a restriction if found" do
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

      CoronavirusRestrictionArea.stubs(:find).with("E32000014").returns(nil)
      area = CoronavirusRestrictionArea.new(
        "E09000033",
        {
          "name" => "Westminster City Council",
          "restrictions" => [
            {
              "alert_level" => 1,
              "start_date" => Date.yesterday,
              "start_time" => "00:01",
            },
          ],
        },
      )
      CoronavirusRestrictionArea.stubs(:find).with("E09000033").returns(area)

      instance = described_class.new("SW1A 2AA")
      assert_instance_of described_class::EnglandResult, instance.england_result
      assert 1, instance.england_result.current_restriction.alert_level
    end

    it "returns nil for an English postcode where no restriction is found" do
      CoronavirusRestrictionArea.stubs(:find).returns(nil)

      assert_nil described_class.new("E1 8QS").england_result
    end

    it "returns nil when the input has an error" do
      assert_nil described_class.new("").england_result
    end

    it "returns nil where mapit doesn't have any areas for the postcode" do
      stub_mapit_has_a_postcode_and_areas("SW1A 2AA", [], [])

      assert_nil described_class.new("SW1A 2AA").england_result
    end

    it "returns nil for a devolved nation" do
      assert_nil described_class.new("EH1 1BE").england_result
    end
  end

  describe "#devolved_nation_result" do
    it "returns an DevolvedNationResult object when a location is found" do
      instance = described_class.new("EH1 1BE")
      assert_instance_of described_class::DevolvedNationResult, instance.devolved_nation_result
      assert "Scotland", instance.devolved_nation_result.country
    end

    it "returns nil when the input has an error" do
      assert_nil described_class.new("").devolved_nation_result
    end

    it "returns nil where mapit doesn't have any areas for the postcode" do
      stub_mapit_has_a_postcode_and_areas("G1 1BX", [], [])

      assert_nil described_class.new("G1 1BX").devolved_nation_result
    end

    it "returns nil for an English postcode" do
      assert_nil described_class.new("E1 8QS").devolved_nation_result
    end
  end
end
