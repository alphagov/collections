require "test_helper"

describe CoronavirusRestrictionArea do
  describe ".all" do
    it "returns an array of CoronavirusRestrictionArea models" do
      assert(described_class.all.all? { |item| item.is_a?(described_class) })
    end
  end

  describe ".find" do
    it "can find a CoronavirusRestrictionArea by gss_code" do
      gss_code = described_class.all.first.gss_code
      assert gss_code, described_class.find(gss_code).gss_code
    end

    it "returns nil if it can't find a CoronavirusRestrictionArea" do
      assert_nil described_class.find("not-a-gss-code")
    end
  end

  describe "#restrictions" do
    it "returns an array of CoronavirusRestrictionArea::Restriction objects" do
      instance = described_class.new("gss-code", {
        "name" => "Tattooine",
        "restrictions" => [
          {
            "alert_level" => 2,
            "start_date" => Date.new(2020, 10, 1),
            "start_time" => "10:00",
          },
          {
            "alert_level" => 3,
            "start_date" => Date.new(2021, 1, 15),
            "start_time" => "10:00",
          },
        ],
      })

      assert(instance.restrictions.all? { |r| r.is_a?(described_class::Restriction) })
    end
  end

  describe "#current_restriction" do
    it "returns the restriction in the past with the latest start date" do
      first_restriction = { "alert_level" => 3, "start_date" => Date.new(2020, 8, 1), "start_time" => "10:00" }
      second_restriction = { "alert_level" => 2, "start_date" => Date.new(2020, 10, 1), "start_time" => "10:00" }
      instance = described_class.new("gss-code", {
        "name" => "Naboo",
        "restrictions" => [first_restriction, second_restriction],
      })

      restriction = instance.current_restriction
      assert_instance_of described_class::Restriction, restriction
      assert_equal 2, restriction.alert_level
      assert_equal Time.zone.parse("2020-10-1 10:00"), restriction.start_time
    end

    it "returns nil when there are no current restrictions" do
      instance = described_class.new("gss-code", {
        "name" => "Naboo",
        "restrictions" => [
          { "alert_level" => 2, "start_date" => Date.new(2021, 1, 1), "start_time" => "10:00" },
        ],
      })

      travel_to(Time.zone.parse("2020-12-01")) do
        assert_nil instance.current_restriction
      end
    end
  end

  describe "#future_restriction" do
    it "returns the restriction in the future with the earliest start date" do
      first_restriction = { "alert_level" => 3, "start_date" => Date.new(2021, 8, 1), "start_time" => "10:00" }
      second_restriction = { "alert_level" => 2, "start_date" => Date.new(2021, 10, 1), "start_time" => "10:00" }
      instance = described_class.new("gss-code", {
        "name" => "Mandalore",
        "restrictions" => [first_restriction, second_restriction],
      })
      travel_to(Time.zone.parse("2020-12-01")) do
        restriction = instance.future_restriction
        assert_instance_of described_class::Restriction, restriction
        assert_equal 3, restriction.alert_level
        assert_equal Time.zone.parse("2021-8-1 10:00"), restriction.start_time
      end
    end

    it "returns nil when there are no future restrictions" do
      instance = described_class.new("gss-code", {
        "name" => "Mandalore",
        "restrictions" => [
          { "alert_level" => 2, "start_date" => Date.new(2020, 1, 1), "start_time" => "10:00" },
        ],
      })
      assert_nil instance.future_restriction
    end
  end
end
