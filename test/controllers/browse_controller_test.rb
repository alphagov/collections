require "test_helper"

describe BrowseController do
  describe "GET index" do
    it "set slimmer format of browse" do
      IndexBrowsePage.stubs(:new).returns(stubbed_page_object)

      get :index

      assert_equal "browse", response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      IndexBrowsePage.stubs(:new).returns(stubbed_page_object)

      get :index

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  describe "GET top_level_browse_page" do
    it "404 if the section does not exist" do
      TopLevelBrowsePage.stubs(:new).with("banana").raises(GdsApi::HTTPNotFound.new(404))

      get :top_level_browse_page, top_level_slug: "banana"

      assert_response 404
    end

    it "return a cacheable 404 without calling content_api if the section slug is invalid" do
      get :top_level_browse_page, top_level_slug: "this & that"

      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end

    it "set slimmer format of browse" do
      TopLevelBrowsePage.stubs(:new).returns(stubbed_page_object)

      get :top_level_browse_page, top_level_slug: "crime-and-justice"

      assert_equal "browse",  response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      TopLevelBrowsePage.stubs(:new).returns(stubbed_page_object)

      get :top_level_browse_page, top_level_slug: "crime-and-justice"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  describe "GET second_level_browse_page" do
    it "404 if the section does not exist" do
      SecondLevelBrowsePage.stubs(:new).with("crime-and-justice", "frume").raises(GdsApi::HTTPNotFound.new(404))

      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "frume"

      assert_response 404
    end

    it "return a cacheable 404 without calling content_api if the section slug is invalid" do
      get :second_level_browse_page, top_level_slug: "this & that", second_level_slug: "foo"

      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end

    it "set slimmer format of browse" do
      SecondLevelBrowsePage.stubs(:new).returns(stubbed_page_object)

      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "judges"

      assert_equal "browse",  response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      SecondLevelBrowsePage.stubs(:new).returns(stubbed_page_object)

      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "judges"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  def stubbed_page_object
    page = stubs('page')
    page.stubs(
      slimmer_breadcrumb_options: [],
      title: 'Title',
      description: 'All about title',
      lists: stub(:curated? => false, :each => nil),
      related_topics: [],
      active_top_level_browse_page: OpenStruct.new(title: 'aosudgad'),
      second_level_browse_pages: [],
      top_level_browse_pages: []
    )
    page
  end
end
