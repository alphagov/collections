require "test_helper"

describe CoronavirusRestrictionSearch::DevolvedNationResult do
  describe "#area_name" do
    it "returns the name of the first area with a type we recognise" do
      locations = [
        mock(type: "ABC"),
        mock(type: "UTA", name: "Hoth"),
      ]

      instance = described_class.new("E1 8QS", locations)
      assert "Hoth", instance.area_name
    end

    it "returns nil if there isn't an area type we recognise" do
      locations = [mock(type: "ABC")]

      instance = described_class.new("E1 8QS", locations)
      assert_nil instance.area_name
    end
  end

  describe "#country" do
    it "returns the name of the first country in the locations" do
      locations = [mock(country: "Scotland")]

      instance = described_class.new("EH1 1BE", locations)
      assert "Scotland", instance.country
    end
  end

  describe "#northern_ireland?" do
    it "returns true if the country is Northern Ireland" do
      locations = [mock(country: "Northern Ireland")]

      assert described_class.new("BT15 3JX", locations).northern_ireland?
    end
  end

  describe "#scotland?" do
    it "returns true if the country is Scotland" do
      locations = [mock(country: "Scotland")]

      assert described_class.new("EH1 1BE", locations).scotland?
    end
  end

  describe "#wales?" do
    it "returns true if the country is Wales" do
      locations = [mock(country: "Wales")]

      assert described_class.new("CF10 5FN", locations).wales?
    end
  end
end
