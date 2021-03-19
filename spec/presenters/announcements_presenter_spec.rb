RSpec.describe AnnouncementsPresenter do
  describe "slug with a locale" do
    let(:presenter) { described_class.new("boris-johnson.cy", filter_key: "people") }

    it "uses a locale-less slug in the links" do
      links = presenter.links
      expect("/email-signup?link=/government/people/boris-johnson").to eq(links[:email_signup])
      expect("/search/news-and-communications.atom?people=boris-johnson").to eq(links[:subscribe_to_feed])
      expect("/search/news-and-communications?people=boris-johnson").to eq(links[:link_to_news_and_communications])
    end
  end
end
