require "test_helper"

class CountdownClockTest < ActiveSupport::TestCase
  def clock
    CountdownClock.new
  end

  describe "#days_left" do
    it "gives the days left until end of transition period" do
      day_before_transition_period_ends = Date.new(2020, 12, 31)
      travel_to day_before_transition_period_ends
      assert_equal("01", clock.days_left)
    end
  end

  describe "#show?" do
    it "returns true until 23.59 on December 31st 2020" do
      minute_to_midnight_on_brexit_eve = Time.zone.local(2020, 12, 31, 23, 59)
      travel_to minute_to_midnight_on_brexit_eve
      assert_equal(true, clock.show?)
    end

    it "returns false from midnight on the eve of January 1st 2021" do
      midnight_on_brexit_eve = Time.zone.local(2020, 12, 31, 24, 0)
      travel_to midnight_on_brexit_eve
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
