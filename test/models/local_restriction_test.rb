require "test_helper"

describe LocalRestriction do
  describe ".all" do
    it "contains an array of LocalRestriction models" do
      assert described_class.all.all? { |item| item.is_a?(described_class) }
    end
  end

  describe ".find" do
    it "can find a LocalRestriction by gss_code" do
      gss_code = described_class.all.first.gss_code
      assert_kind_of described_class, described_class.find(gss_code)
    end

    it "returns nil if it can't find a LocalRestriction" do
      assert_nil described_class.find("not-a-gss-code")
    end
  end

  describe "#current_alert_level" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Tattooine",
        "restrictions" => [{ "alert_level" => 2,
                             "start_date" => "2020-10-01",
                             "start_time" => "10:00", }]
      })
    end

    it "returns the alert level when a current alert exists" do
      assert_equal 2, instance.current_alert_level
    end

    it "returns nil when there is not a current alert" do
      travel_to(Time.zone.parse("2020-01-01")) do
        assert_nil instance.current_alert_level
      end
    end
  end

  describe "#future_alert_level" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Coruscant Planetary Council",
        "restrictions" => [{ "alert_level" => 3,
                             "start_date" => "2021-01-01",
                             "start_time" => "10:00", }]
      })
    end

    it "returns the alert level when a future alert exists" do
      travel_to(Time.zone.parse("2020-12-25")) do
        assert_equal 3, instance.future_alert_level
      end
    end

    it "returns nil when there is not a current alert" do
      travel_to(Time.zone.parse("2021-02-14")) do
        assert_nil instance.future_alert_level
      end
    end
  end

  describe "#current" do
    it "returns the restriction in the past with the latest start date" do
      first_restriction = { "alert_level" => 3, "start_date" => "2020-08-01", "start_time" => "10:00" }
      second_restriction = { "alert_level" => 2, "start_date" => "2020-10-01", "start_time" => "10:00" }
      instance = described_class.new("gss-code", {
        "name" => "Naboo",
        "restrictions" => [first_restriction, second_restriction],
      })
      assert_equal second_restriction, instance.current
    end

    it "returns nil when there are no current restrictions" do
      instance = described_class.new("gss-code", {
        "name" => "Naboo",
        "restrictions" => [],
      })
      assert_nil instance.current
    end
  end

  describe "#future" do
    it "returns the restriction in the future with the earliest start date" do
      first_restriction = { "alert_level" => 3, "start_date" => "2021-08-01", "start_time" => "10:00" }
      second_restriction = { "alert_level" => 2, "start_date" => "2021-10-01", "start_time" => "10:00" }
      instance = described_class.new("gss-code", {
        "name" => "Mandalore",
        "restrictions" => [first_restriction, second_restriction],
      })
      travel_to(Time.zone.parse("2020-12-25")) do
        assert_equal first_restriction, instance.future
      end
    end

    it "returns nil when there are no future restrictions" do
      instance = described_class.new("gss-code", {
        "name" => "Mandalore",
        "restrictions" => [],
      })
      assert_nil instance.future
    end
  end

  describe "#tier_three?" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Alderaan",
        "restrictions" => [{ "alert_level" => 3,
                             "start_date" => "2020-10-01",
                             "start_time" => "10:00", }]
      })
    end

    it "returns true if there is current restriction in tier 3" do
      travel_to(Time.zone.parse("2020-12-01")) do
        assert instance.tier_three?
      end
    end

    it "returns false if there is not a current tier 3 restriction" do
      travel_to(Time.zone.parse("2020-09-01")) do
        assert_not instance.tier_three?
      end
    end
  end

  describe "#tier_two?" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Alderaan",
        "restrictions" => [{ "alert_level" => 2,
                             "start_date" => "2020-10-01",
                             "start_time" => "10:00", }]
      })
    end

    it "returns true if there is current restriction in tier 2" do
      travel_to(Time.zone.parse("2020-12-01")) do
        assert instance.tier_two?
      end
    end

    it "returns false if there is not a current tier 2 restriction" do
      travel_to(Time.zone.parse("2020-09-01")) do
        assert_not instance.tier_two?
      end
    end
  end

  describe "#tier_one?" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Alderaan",
        "restrictions" => [{ "alert_level" => 1,
                             "start_date" => "2020-10-01",
                             "start_time" => "10:00", }]
      })
    end

    it "returns true if there is current restriction in tier 1" do
      travel_to(Time.zone.parse("2020-12-01")) do
        assert instance.tier_one?
      end
    end

    it "returns false if there is not a current tier 1 restriction" do
      travel_to(Time.zone.parse("2020-09-01")) do
        assert_not instance.tier_one?
      end
    end
  end
end
