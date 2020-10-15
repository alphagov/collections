require "test_helper"

describe LocalRestriction do
  let(:restriction) { described_class.new("E08000001") }

  before do
    LocalRestriction.any_instance.stubs(:file_name).returns("test/fixtures/local-restrictions.yaml")
  end

  it "returns the area name" do
    assert_equal "Tatooine", restriction.area_name
  end

  it "returns the alert level" do
    assert_equal 4, restriction.alert_level
  end

  it "returns nil values if the gss code doesn't exist" do
    local_restriction = described_class.new("fake code")
    assert_empty local_restriction.restriction
    assert_nil local_restriction.area_name
  end

  it "returns the latest past date as a current restriction" do
    travel_to Time.zone.local(2020, 10, 15, 10, 10, 10)
    current_restriction = {
      "alert_level" => 3,
      "start_date" => "2020-10-12".to_date,
      "start_time" => "00:01",
    }
    assert_equal current_restriction, restriction.current
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
end
