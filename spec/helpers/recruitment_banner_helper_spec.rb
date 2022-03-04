RSpec.describe RecruitmentBannerHelper do
  include RecruitmentBannerHelper

  describe "#show_banner?" do
    it "checks that a page should display the banner" do
      expect(show_banner?("/browse/employing-people")).to be true
    end

    it "checks that a page shows that banner" do
      expect(show_banner?("/browse/stuff")).to be false
    end
  end
end
