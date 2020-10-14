require "test_helper"

class CountdownClockTest < ActiveSupport::TestCase
  def clock
    CountdownClock.new
  end

  describe "#days_left" do
    it "gives the days left until end of transition period" do
      day_before_transition_period_ends = Date.new(2020, 12, 31)
      travel_to day_before_transition_period_ends
      assert_equal(1, clock.days_left)
    end
  end

  describe "#show?" do
    it "returns false on the day the transition period ends" do
      day_transition_period_ends = Date.new(2021, 1, 1)
      travel_to day_transition_period_ends
      assert_equal(false, clock.show?)
    end
  end

  describe "#days_left" do
    it "pluralizes day if necessary" do
      one_day_left = Date.new(2020, 12, 31)
      travel_to one_day_left
      assert_equal("day to go", clock.days_text)

      two_days_left = Date.new(2020, 12, 30)
      travel_to two_days_left
      assert_equal("days to go", clock.days_text)
    end
  end
end
