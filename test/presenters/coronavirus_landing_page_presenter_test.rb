require "test_helper"
require_relative "../../test/support/coronavirus_helper"

describe CoronavirusLandingPagePresenter do
  it "provides getter methods for all component keys" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    %i[stay_at_home guidance announcements_label announcements nhs_banner sections topic_section notifications].each do |method|
      assert_respond_to(presenter, method)
    end
  end
end
