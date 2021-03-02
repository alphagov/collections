require "gds_api/test_helpers/mapit"

RSpec.describe PostcodeLocalRestrictionSearch do
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
      expect("sw1a 2aa").to match(pattern)
      expect("LS11UR").to match(pattern)
      expect("BT15 3JX").to match(pattern)
    end

    it "doesn't match invalid postcodes" do
      expect("sw1a").not_to match(pattern)
      expect("LS 11UR").not_to match(pattern)
      expect(" BT15 3JX ").not_to match(pattern)
    end

    it "doesn't match quirky non-geographical postcodes" do
      expect("GIR 0AA").not_to match(pattern)
    end
  end

  describe "#sanitised_postcode" do
    it "returns the postcode as a formatted UK postcode" do
      instance = described_class.new("e18qs")
      expect(instance.sanitised_postcode).to eq("E1 8QS")
    end

    it "accepts postcodes that have non-alphanumeric characters" do
      instance = described_class.new("E1!@£$%^&*8QS")
      expect(instance.sanitised_postcode).to eq("E1 8QS")
    end

    it "accepts and fixes common character errors in postcodes" do
      instance = described_class.new("EI 8QS")
      expect(instance.sanitised_postcode).to eq("E1 8QS")
    end
  end

  describe "#error_code" do
    it "returns nil when there isn't an error" do
      instance = described_class.new("E1 8QS")
      expect(instance.error_code).to be_nil
    end

    it "returns 'postcodeLeftBlank' for a blank postcode" do
      instance = described_class.new("")
      expect(instance.error_code).to eq("postcodeLeftBlank")
    end

    it "returns 'postcodeLeftBlankSanitized' for an unsalvagable postcode" do
      instance = described_class.new("!@£$%^&*(")
      expect(instance.error_code).to eq("postcodeLeftBlankSanitized")
    end

    it "returns 'invalidPostcodeFormat' for a non postcode" do
      instance = described_class.new("not-a-postcode")
      expect(instance.error_code).to eq("invalidPostcodeFormat")
    end

    it "returns 'fullPostcodeNoMapitMatch' when mapit doesn't know the postcode" do
      stub_mapit_does_not_have_a_postcode("E1 8QS")
      instance = described_class.new("E1 8QS")
      expect(instance.error_code).to eq("fullPostcodeNoMapitMatch")
    end

    it "returns 'fullPostcodeNoMapitValidation' when mapit doesn't like the postcode" do
      stub_mapit_does_not_have_a_bad_postcode("E1 8QS")
      instance = described_class.new("E1 8QS")
      expect(instance.error_code).to eq("fullPostcodeNoMapitValidation")
    end
  end

  describe "#invalid_postcode?" do
    it "returns true for an invalid postcode scenarios" do
      expect(described_class.new("not-a-postcode").invalid_postcode?).to be(true)
    end

    it "returns false when the input is a valid postcode" do
      expect(described_class.new("E1 8QS").invalid_postcode?).to be(false)
    end

    it "returns false if mapit doesn't know about the postcode" do
      stub_mapit_does_not_have_a_postcode("E1 8QS")

      expect(described_class.new("E1 8QS").invalid_postcode?).to be(false)
    end

    it "returns true for missing postcode scenarios" do
      expect(described_class.new("").invalid_postcode?).to be(true)
    end
  end

  describe "#no_restriction?" do
    it "returns true when an english postcode has no restriction data" do
      expect(LocalRestriction)
      .to receive(:find)
      .with("E09000030")
      .and_return(nil)

      expect(described_class.new("E1 8QS").no_restriction?).to be(true)
    end

    it "returns false when an english postcode has a restriction" do
      expect(LocalRestriction)
      .to receive(:find)
      .with("E09000030")
      .and_return({ "name" => "London Borough of Tower Hamlets" })

      expect(described_class.new("E1 8QS").no_restriction?).to be(false)
    end

    it "returns false for a develolved nation postcode" do
      stub_mapit_has_a_postcode_and_areas("EH7 4EW", [], [{
        "gss" => "S12000036",
        "name" => "Edinburgh",
        "type" => "LBO",
        "country_name" => "Scotland",
      }])

      expect(described_class.new("EH7 4EW").no_restriction?).to be(false)
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

      expect(LocalRestriction)
      .to receive(:find)
      .with("E32000014")
      .and_return(nil)

      restriction = LocalRestriction.new("E09000033", { "name" => "Westminster City Council" })

      expect(LocalRestriction)
      .to receive(:find)
      .with("E09000033")
      .and_return(restriction)

      expect(described_class.new("SW1A 2AA").local_restriction).to eq(restriction)
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
      expect(LocalRestriction)
      .to receive(:find)
      .with("E09000033")
      .and_return(nil)

      expect(described_class.new("SW1A 2AA").local_restriction).to be_nil
    end

    it "returns nil when the postcode has an error" do
      expect(described_class.new("not-a-postcode").local_restriction).to be_nil
    end

    it "returns nil when Mapit has no information for the location" do
      stub_mapit_has_a_postcode_and_areas("SW1A 2AA", [], [])

      expect(described_class.new("SW1A 2AA").local_restriction).to be_nil
    end
  end
end
