require "test_helper"
require "mocha"

class CoronavirusLocalRestrictionsConstraintTest < ActiveSupport::TestCase
  describe "#matches?" do
    it "returns false when the environment is production" do
      Rails.stubs(:env).returns(ActiveSupport::StringInquirer.new("production"))
      assert_equal described_class.new.matches?, false
    end

    it "returns true if the environment is not production" do
      assert_equal described_class.new.matches?, true
    end
  end
end
