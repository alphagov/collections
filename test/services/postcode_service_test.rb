require "test_helper"

describe PostcodeService do
  describe "#valid?" do
    it "returns true if postcode is valid" do
      postcode = "E1 8QS"
      assert(described_class.new(postcode).valid?)
    end

    it "returns false if the postcode is not valid" do
      postcode = "invalid postcode"
      assert_not(described_class.new(postcode).valid?)
    end

    it "returns false for partial postcodes" do
      postcode = "SW1A"
      assert_not(described_class.new(postcode).valid?)
    end
  end

  describe "#sanitize" do
    it "strips trailing spaces from entered postcodes" do
      assert_equal "WC2B 6NH", described_class.new("WC2B 6NH ").sanitize
    end

    it "transposes O/0 and I/1 if necessary" do
      assert_equal "W1A 0AA", described_class.new("WIA OAA").sanitize
    end

    it "returns nil if the postcode parameter is nil or an empty string" do
      assert_nil described_class.new("").sanitize
    end

    it "removes special characters from the start of the postcode" do
      assert_equal "WC2B 6NH", described_class.new(".WC2B6NH").sanitize
    end

    it "converts the postcode to uppercase" do
      assert_equal "WC2B 6NH", described_class.new("wc2b6nh").sanitize
    end

    it "removes non-breaking spaces from the postcode" do
      assert_equal "WC1A 1AA", described_class.new("\u00A0WC1A1AA").sanitize
    end
  end
end
