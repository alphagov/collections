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

  describe "#initialize" do
    it "raises an error when initialised without any current restrictions" do
      assert_raises RuntimeError do
        described_class.new("gss-code", {
          "name" => "Tattooine",
          "restrictions" => [
            {
              "alert_level" => 2,
              "start_date" => Date.tomorrow,
              "start_time" => "10:00",
            },
          ],
        })
      end
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
      assert_equal second_restriction["alert_level"], restriction.alert_level
      assert_equal Time.zone.parse("#{second_restriction['start_date']} #{second_restriction['start_time']}"),
                   restriction.start_time
    end
  end

  describe "#future_restriction" do
    it "returns the restriction in the future with the earliest start date" do
      current_restriction = { "alert_level" => 1, "start_date" => Date.new(2020, 8, 1), "start_time" => "10:00" }
      next_restriction = { "alert_level" => 3, "start_date" => Date.new(2021, 8, 1), "start_time" => "10:00" }
      further_restriction = { "alert_level" => 2, "start_date" => Date.new(2021, 10, 1), "start_time" => "10:00" }

      instance = described_class.new("gss-code", {
        "name" => "Mandalore",
        "restrictions" => [current_restriction, next_restriction, further_restriction],
      })

      travel_to(Time.zone.parse("2020-12-01")) do
        restriction = instance.future_restriction
        assert_instance_of described_class::Restriction, restriction
        assert_equal next_restriction["alert_level"], restriction.alert_level
        assert_equal Time.zone.parse("#{next_restriction['start_date']} #{next_restriction['start_time']}"),
                     restriction.start_time
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
