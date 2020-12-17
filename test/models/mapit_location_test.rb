require "test_helper"

describe MapitLocation do
  let(:mapit_area) do
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
    assert_equal("E01000123", described_class.new(mapit_area).gss)
  end

  it "returns the area name" do
    assert_equal("Coruscant Planetary Council", described_class.new(mapit_area).area_name)
  end

  it "returns the country" do
    assert_equal("England", described_class.new(mapit_area).country)
  end

  it "returns the area type" do
    assert_equal("LBO", described_class.new(mapit_area).area_type)
  end

  describe "#england?" do
    it "returns true if the country is England" do
      assert(described_class.new(mapit_area).england?)
    end
  end

  describe "#scotland?" do
    it "returns true if the country is Scotland" do
      mapit_area["country_name"] = "Scotland"

      assert(described_class.new(mapit_area).scotland?)
    end
  end

  describe "#wales?" do
    it "returns true if the country is Wales" do
      mapit_area["country_name"] = "Wales"

      assert(described_class.new(mapit_area).wales?)
    end
  end

  describe "#northern_ireland?" do
    it "returns true if the country is Northern Ireland" do
      mapit_area["country_name"] = "Northern Ireland"

      assert(described_class.new(mapit_area).northern_ireland?)
    end
  end
end
