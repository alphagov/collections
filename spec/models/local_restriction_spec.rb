RSpec.describe LocalRestriction do
  describe ".all" do
    it "contains an array of LocalRestriction models" do
      expect(described_class.all.all? { |item| item.is_a?(described_class) })
    end
  end

  describe ".find" do
    it "can find a LocalRestriction by gss_code" do
      gss_code = described_class.all.first.gss_code
      expect(described_class.find(gss_code).gss_code).to be(gss_code)
    end

    it "returns nil if it can't find a LocalRestriction" do
      expect(described_class.find("not-a-gss-code")).to be_nil
    end
  end

  describe "#current_alert_level" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Tattooine",
        "restrictions" => [{ "alert_level" => 2,
                             "start_date" => Date.new(2020, 10, 1),
                             "start_time" => "10:00" }],
      })
    end

    it "returns the alert level when a current alert exists" do
      expect(instance.current_alert_level).to eq(2)
    end

    it "returns nil when there is not a current alert" do
      travel_to(Time.zone.parse("2020-01-01")) do
        expect(instance.current_alert_level).to be_nil
      end
    end
  end

  describe "#future_alert_level" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Coruscant Planetary Council",
        "restrictions" => [{ "alert_level" => 3,
                             "start_date" => Date.new(2021, 1, 1),
                             "start_time" => "10:00" }],
      })
    end

    it "returns the alert level when a future alert exists" do
      travel_to(Time.zone.parse("2020-12-01")) do
        expect(instance.future_alert_level).to eq(3)
      end
    end

    it "returns nil when there is not a future alert" do
      travel_to(Time.zone.parse("2021-02-01")) do
        expect(instance.future_alert_level).to be_nil
      end
    end
  end

  describe "#current" do
    it "returns the restriction in the past with the latest start date" do
      first_restriction = { "alert_level" => 3, "start_date" => Date.new(2020, 8, 1), "start_time" => "10:00" }
      second_restriction = { "alert_level" => 2, "start_date" => Date.new(2020, 10, 1), "start_time" => "10:00" }
      instance = described_class.new("gss-code", {
        "name" => "Naboo",
        "restrictions" => [first_restriction, second_restriction],
      })
      expect(instance.current).to eq(second_restriction)
    end

    it "returns nil when there are no current restrictions" do
      instance = described_class.new("gss-code", {
        "name" => "Naboo",
        "restrictions" => [
          { "alert_level" => 2, "start_date" => Date.new(2021, 1, 1), "start_time" => "10:00" },
        ],
      })

      travel_to(Time.zone.parse("2020-12-01")) do
        expect(instance.current).to be_nil
      end
    end
  end

  describe "#future" do
    it "returns the restriction in the future with the earliest start date" do
      first_restriction = { "alert_level" => 3, "start_date" => Date.new(2021, 8, 1), "start_time" => "10:00" }
      second_restriction = { "alert_level" => 2, "start_date" => Date.new(2021, 10, 1), "start_time" => "10:00" }
      instance = described_class.new("gss-code", {
        "name" => "Mandalore",
        "restrictions" => [first_restriction, second_restriction],
      })
      travel_to(Time.zone.parse("2020-12-01")) do
        expect(instance.future).to eq(first_restriction)
      end
    end

    it "returns nil when there are no future restrictions" do
      instance = described_class.new("gss-code", {
        "name" => "Mandalore",
        "restrictions" => [
          { "alert_level" => 2, "start_date" => Date.new(2020, 1, 1), "start_time" => "10:00" },
        ],
      })
      expect(instance.future).to be nil
    end
  end

  describe "#tier_three?" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Alderaan",
        "restrictions" => [{ "alert_level" => 3,
                             "start_date" => Date.new(2020, 10, 1),
                             "start_time" => "10:00" }],
      })
    end

    it "returns true if there is current restriction in tier 3" do
      travel_to(Time.zone.parse("2020-12-01")) do
        expect(instance.tier_three?).to be(true)
      end
    end

    it "returns false if there is not a current tier 3 restriction" do
      travel_to(Time.zone.parse("2020-09-01")) do
        expect(instance.tier_three?).to be(false)
      end
    end
  end

  describe "#tier_two?" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Alderaan",
        "restrictions" => [{ "alert_level" => 2,
                             "start_date" => Date.new(2020, 10, 1),
                             "start_time" => "10:00" }],
      })
    end

    it "returns true if there is current restriction in tier 2" do
      travel_to(Time.zone.parse("2020-12-01")) do
        expect(instance.tier_two?).to be(true)
      end
    end

    it "returns false if there is not a current tier 2 restriction" do
      travel_to(Time.zone.parse("2020-09-01")) do
        expect(instance.tier_two?).to be(false)
      end
    end
  end

  describe "#tier_one?" do
    let(:instance) do
      described_class.new("gss-code", {
        "name" => "Alderaan",
        "restrictions" => [{ "alert_level" => 1,
                             "start_date" => Date.new(2020, 10, 1),
                             "start_time" => "10:00" }],
      })
    end

    it "returns true if there is current restriction in tier 1" do
      travel_to(Time.zone.parse("2020-12-01")) do
        expect(instance.tier_one?).to be(true)
      end
    end

    it "returns false if there is not a current tier 1 restriction" do
      travel_to(Time.zone.parse("2020-09-01")) do
        expect(instance.tier_one?).to be(false)
      end
    end
  end
end
