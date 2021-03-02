RSpec.describe MapitPostcodeResponse do
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
    expect(described_class.new(mapit_location).gss).to eq("E01000123")
  end

  it "returns the area name" do
    expect(described_class.new(mapit_location).area_name).to eq("Coruscant Planetary Council")
  end

  it "returns the country" do
    expect(described_class.new(mapit_location).country).to eq("England")
  end

  it "returns the area type" do
    expect(described_class.new(mapit_location).area_type).to eq("LBO")
  end

  describe "#england?" do
    it "returns true if the country is England" do
      assert(described_class.new(mapit_location).england?)
    end
  end

  describe "#scotland?" do
    it "returns true if the country is Scotland" do
      mapit_location["country_name"] = "Scotland"

      expect(described_class.new(mapit_location).scotland?).to be(true)
    end
  end

  describe "#wales?" do
    it "returns true if the country is Wales" do
      mapit_location["country_name"] = "Wales"

      expect(described_class.new(mapit_location).wales?).to be(true)
    end
  end

  describe "#northern_ireland?" do
    it "returns true if the country is Northern Ireland" do
      mapit_location["country_name"] = "Northern Ireland"

      expect(described_class.new(mapit_location).northern_ireland?).to be(true)
    end
  end
end
