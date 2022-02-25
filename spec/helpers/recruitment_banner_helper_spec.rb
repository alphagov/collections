RSpec.describe RecruitmentBannerHelpers do
  include RecruitmentBannerHelpers

  describe "#hide_banner?" do
    it "checks that a page should display the banner" do
      expect(hide_banner?("/browse/business")).to be false
    end

    it "checks that a page hides that banner" do
      expect(hide_banner?("/browse/stuff")).to be true
    end
  end

  describe "#show_banner?" do
    it "checks that a page should display the banner" do
      expect(show_banner?("/browse/business")).to be true
    end

    it "checks that a page shows that banner" do
      expect(show_banner?("/browse/stuff")).to be false
    end
  end
end
