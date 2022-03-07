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

  describe "#study_url_for" do
    it "returns common study url" do
      expect(study_url_for("/browse/tax/blah-blah-blah")).to eq("https://GDSUserResearch.optimalworkshop.com/treejack/lb5eu75l")
    end

    it "returns the additional study link" do
      expect(study_url_for("/browse/employing-people/blah-blah-blah")).to eq("https://GDSUserResearch.optimalworkshop.com/treejack/724268fr")
    end
  end
end
