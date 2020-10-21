require "test_helper"

describe LocalRestriction do
  let(:restriction) { described_class.new("E08000123") }

  before do
    LocalRestriction.any_instance.stubs(:file_name).returns("test/fixtures/local-restrictions.yaml")
  end

  it "returns the area name" do
    assert_equal "Tatooine", restriction.area_name
  end

  it "returns the current alert level" do
    travel_to Time.zone.local(2020, 10, 15, 10, 10, 10)
    assert_equal 2, restriction.current_alert_level
    travel_back
  end

  it "returns nil values if the gss code doesn't exist" do
    local_restriction = described_class.new("fake code")
    assert_empty local_restriction.restriction
    assert_nil local_restriction.area_name
  end

  it "returns the latest past date as a current restriction" do
    travel_to Time.zone.local(2020, 10, 15, 10, 10, 10)
    current_restriction = {
      "alert_level" => 2,
      "start_date" => "2020-10-12".to_date,
      "start_time" => "00:01",
    }
    assert_equal current_restriction, restriction.current
    travel_back
  end

  it "returns today as a current restriction when the start time is in the past" do
    travel_to Time.zone.local(2022, 10, 12, 20, 10, 10)
    expected_restriction = {
      "alert_level" => 3,
      "start_date" => "2022-10-12".to_date,
      "start_time" => "18:00",
    }
    assert_equal expected_restriction, restriction.current
    travel_back
  end

  it "returns the soonest future date as a current restriction" do
    travel_to Time.zone.local(2020, 10, 15, 10, 10, 10)
    future_restriction = {
      "alert_level" => 3,
      "start_date" => "2021-10-12".to_date,
      "start_time" => "00:01",
    }
    assert_equal future_restriction, restriction.future
    travel_back
  end

  it "returns today as a future restriction when the start time is in the future" do
    travel_to Time.zone.local(2022, 10, 12, 10, 10, 10)
    expected_restriction = {
      "alert_level" => 3,
      "start_date" => "2022-10-12".to_date,
      "start_time" => "18:00",
    }
    assert_equal expected_restriction, restriction.future
    travel_back
  end

  it "returns nil when there are no future restrictions" do
    travel_to Time.zone.local(2020, 10, 15, 10, 10, 10)
    restriction = described_class.new("E08000456")
    assert_nil restriction.future
    travel_back
  end

  it "returns nil when there are no current restrictions" do
    travel_to Time.zone.local(2020, 10, 15, 10, 10, 10)
    restriction = described_class.new("E08000789")
    assert_nil restriction.current
    travel_back
  end
end
