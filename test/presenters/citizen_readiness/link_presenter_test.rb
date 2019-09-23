require "test_helper"

describe CitizenReadiness::LinkPresenter do
  include TaxonHelpers

  let(:presenter) { described_class.new("/visit-europe-brexit") }

  describe "#link" do
    it "should return a link to the required page" do
      assert_equal("/visit-europe-brexit", presenter.link)
    end
  end

  describe "#description" do
    it "should return description for the page from translations" do
      assert_equal("Includes passports, driving and travel, EHIC cards, pets and mobile roaming fees", presenter.description)
    end
  end

  describe "tracking" do
    it "should contain tracking data" do
      assert_equal({ "track-category" => "navGridContentClicked", "track-action" => 1, "track-label" => "Visiting Europe" },
                   presenter.featured_data_attributes(1))
      assert_equal({ "track-category" => "sideNavTopics", "track-action" => "Visiting Europe" },
                   presenter.sidebar_data_attributes)
    end
  end
end
