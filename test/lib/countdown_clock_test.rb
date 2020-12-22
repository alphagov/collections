require "test_helper"

class CountdownClockTest < ActiveSupport::TestCase
  def clock
    CountdownClock.new
  end

  describe "#days_left" do
    it "gives the days left until end of transition period" do
      nine_am_on_brexit_eve = Time.zone.local(2020, 12, 31, 9, 0)
      travel_to nine_am_on_brexit_eve
      assert_equal("01", clock.days_left)
    end
  end

  describe "#show?" do
    it "returns true until 23.29 on December 31st 2020" do
      one_minute_before_component_shut_off_time = Time.zone.local(2020, 12, 31, 23, 29)
      travel_to one_minute_before_component_shut_off_time
      assert_equal(true, clock.show?)
    end

    it "returns false from 23.31 on December 31st 2020" do
      one_minute_after_component_shut_off_time = Time.zone.local(2020, 12, 31, 23, 30)
      travel_to one_minute_after_component_shut_off_time
      assert_equal(false, clock.show?)
    end
  end

  describe "#days_text" do
    it "pluralizes day if necessary" do
      one_day_left = Time.zone.local(2020, 12, 31, 9, 0)
      travel_to one_day_left
      assert_equal("day to go", clock.days_text)

      two_days_left = Time.zone.local(2020, 12, 30, 9, 0)
      travel_to two_days_left
      assert_equal("days to go", clock.days_text)
    end
  end
end
