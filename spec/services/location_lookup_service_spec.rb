require "gds_api/test_helpers/mapit"

RSpec.describe LocationLookupService do
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

      expect(data.size).to eq(2)
      expect(data.first).to be_kind_of(MapitPostcodeResponse)
      expect(data.first.gss).to eq("E01000123")

      expect(data.second).to be_kind_of(MapitPostcodeResponse)
      expect(data.second.gss).to eq("E02000456")
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

      expect(data.size).to eq(1)
      expect(data.first).to be_kind_of(MapitPostcodeResponse)
      expect(data.first.gss).to eq("E01000123")
    end

    it "returns an error if the postcode isn't found" do
      postcode = "E18QS"
      stub_mapit_does_not_have_a_postcode(postcode)

      expect(described_class.new(postcode).data).to eq([])
      expect(described_class.new(postcode).error).to_not be nil
      expect(described_class.new(postcode).postcode_not_found?).to be true
    end

    it "returns an error if the postcode is not valid" do
      invalid_postcode = "hello"
      stub_mapit_does_not_have_a_bad_postcode(invalid_postcode)

      expect(described_class.new(invalid_postcode).data).to eq([])
      expect(described_class.new(invalid_postcode).error[:message]).to match(invalid_postcode)
      expect(described_class.new(invalid_postcode).invalid_postcode?).to be true
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

      expect(described_class.new(postcode).lower_tier_area_name).to eq("Coruscant Planetary Council")
    end

    it "returns no information if the postcode is in a valid format but there is no data" do
      postcode = "IM11AF"
      MAPIT_ENDPOINT = Plek.current.find("mapit")

      stub_request(:get, "#{MAPIT_ENDPOINT}/postcode/" + postcode.tr(" ", "+") + ".json")
          .to_return(body: { "postcode" => postcode.to_s, "areas" => {} }.to_json, status: 200)

      expect(described_class.new(postcode).no_information?).to be true
    end
  end
end
