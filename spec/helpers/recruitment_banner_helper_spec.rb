RSpec.describe RecruitmentBannerHelper do
  include RecruitmentBannerHelper

  describe "#study_url_for" do
    let(:survey_url) { RecruitmentBannerHelper::STUDY_URL_ONE }
    it "returns STUDY_URL_ONE for business, tax and employing people browse pages" do
      ["/browse/business/foo", "/browse/tax/foo", "/browse/employing-people/foo"].each do |browse_path|
        expect(study_url_for(browse_path)).to eq survey_url
      end
    end

    it "does not return a survey url for other browse pages" do
      expect(study_url_for("/browse/boring/blah-blah-blah")).to be nil
    end
  end
end
