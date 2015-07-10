require "test_helper"

describe BrowseController do

  describe "GET index" do
    before do
      MainstreamBrowsePage.stubs(:find).with('/browse').returns(stubbed_page_object)
    end

    it "set slimmer format of browse" do
      get :index

      assert_equal "browse", response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      get :index

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  describe "GET top_level_browse_page" do
    describe "for a valid browse page" do
      before do
        MainstreamBrowsePage.stubs(:find).with('/browse/benefits').returns(stubbed_page_object)
      end

      it "set slimmer format of browse" do
        get :top_level_browse_page, top_level_slug: "benefits"

        assert_equal "browse",  response.headers["X-Slimmer-Format"]
      end

      it "set correct expiry headers" do
        get :top_level_browse_page, top_level_slug: "benefits"

        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end

    it "404 if the browse page does not exist" do
      content_store_does_not_have_item("/browse/banana")

      get :top_level_browse_page, top_level_slug: "banana"

      assert_response 404
    end
  end

  describe "GET second_level_browse_page" do
    describe "for a valid browse page" do
      before do
        MainstreamBrowsePage.stubs(:find).with('/browse/benefits/entitlement').returns(stubbed_page_object)
      end

      it "set slimmer format of browse" do
        get :second_level_browse_page, top_level_slug: "benefits", second_level_slug: "entitlement"

        assert_equal "browse",  response.headers["X-Slimmer-Format"]
      end

      it "set correct expiry headers" do
        get :second_level_browse_page, top_level_slug: "benefits", second_level_slug: "entitlement"

        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end

    it "404 if the section does not exist" do
      content_store_does_not_have_item("/browse/crime-and-justice/frume")

      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "frume"

      assert_response 404
    end
  end

  def stubbed_page_object
    stub('MainstreamBrowsePage',
      base_path: "/crime-and-justice",
      title: 'Title',
      description: 'All about title',
      lists: stub(:curated? => false, :each => nil),
      related_topics: [],
      active_top_level_browse_page: OpenStruct.new(title: 'aosudgad'),
      second_level_browse_pages: [],
      top_level_browse_pages: [],
    )
  end
end
