RSpec.describe RecruitmentBannerHelpers do
  include RecruitmentBannerHelpers

  describe "#hide_banner?" do
    it "checks that a page should display the banner" do
      expect(hide_banner?("/browse/visas-immigration/tourist-short-stay-visas")).to be false
    end

    it "checks that a page hides that banner" do
      expect(hide_banner?("/browse/random")).to be true
    end
  end
end
