require "test_helper"

describe AnnouncementsPresenter do
  describe "slug with a locale" do
    before :each do
      @presenter = AnnouncementsPresenter.new("boris-johnson.cy", filter_key: "people")
    end

    it "uses a locale-less slug in the links" do
      links = @presenter.links
      assert_equal links[:email_signup], "/email-signup?link=/government/people/boris-johnson"
      assert_equal links[:subscribe_to_feed], "/search/news-and-communications.atom?people=boris-johnson"
      assert_equal links[:link_to_news_and_communications], "/search/news-and-communications?people=boris-johnson"
    end
  end
end
