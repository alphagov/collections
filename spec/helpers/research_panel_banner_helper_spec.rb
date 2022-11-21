RSpec.describe ResearchPanelBannerHelper do
  include ResearchPanelBannerHelper

  describe "#sign_up_url_for" do
    let(:sign_up_url) { ResearchPanelBannerHelper::SIGNUP_URL }

    it "returns SIGN_UP_URL for benefits, births-deaths-marriages/register-office, disabilities, disabilities/work, driving/driving-licences" do
      ["/browse/benefits",
       "/browse/births-deaths-marriages/register-offices",
       "/browse/disabilities",
       "/browse/disabilities/work",
       "/browse/driving/driving-licences"].each do |browse_path|
        expect(signup_url_for(browse_path)).to eq(sign_up_url)
      end
    end
  end
end
