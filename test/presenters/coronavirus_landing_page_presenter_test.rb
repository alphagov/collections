require "test_helper"
require_relative "../../test/support/coronavirus_helper"

describe CoronavirusLandingPagePresenter do
  it "provides getter methods for all component keys" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    %i[live_stream stay_at_home guidance announcements_label announcements nhs_banner sections country_section topic_section notifications].each do |method|
      assert_respond_to(presenter, method)
    end
  end

  it "can parse date and time" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    assert_equal(presenter.parsed_stream_date, "31 March 2020")
    assert_equal(presenter.parsed_stream_time, "5:00 pm")
  end

  it "displays and empty string if date and time are empty or invalid" do
    bad_values = { "details" => {
      "live_stream" => {
        "date" => "2020/32/01",
        "time" => "30:00",
},
      } }
    presenter = described_class.new(coronavirus_landing_page_content_item.merge(bad_values))
    assert_equal(presenter.parsed_stream_date, "")
    assert_equal(presenter.parsed_stream_time, "")
  end
end
