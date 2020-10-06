require "test_helper"

describe MapitPostcodeResponse do
  let(:mapit_location) do
    {
      "codes" => {
        "ons" => "01",
        "gss" => "E01000123",
        "govuk_slug" => "test-one",
      },
      "name" => "Coruscant Planetary Council",
      "type" => "LBO",
      "country_name" => "England",
    }
  end

  it "returns the gss code" do
    assert_equal("E01000123", described_class.new(mapit_location).gss)
  end

  it "returns the area name" do
    assert_equal("Coruscant Planetary Council", described_class.new(mapit_location).area_name)
  end

  it "returns the country" do
    assert_equal("England", described_class.new(mapit_location).country)
  end

  describe "#england?" do
    it "returns true if the country is England" do
      assert(described_class.new(mapit_location).england?)
    end
  end

  describe "#scotland?" do
    it "returns true if the country is Scotland" do
      mapit_location["country_name"] = "Scotland"

      assert(described_class.new(mapit_location).scotland?)
    end
  end

  describe "#wales?" do
    it "returns true if the country is Wales" do
      mapit_location["country_name"] = "Wales"

      assert(described_class.new(mapit_location).wales?)
    end
  end

  describe "#northern_ireland?" do
    it "returns true if the country is Northern Ireland" do
      mapit_location["country_name"] = "Northern Ireland"

      assert(described_class.new(mapit_location).northern_ireland?)
    end
  end
end
