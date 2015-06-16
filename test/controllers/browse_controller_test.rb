require "test_helper"

describe BrowseController do
  describe "GET index" do
    it "set slimmer format of browse" do
      content_api_has_root_sections(["crime-and-justice"])

      get :index

      assert_equal "browse",  response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      content_api_has_root_sections(["crime-and-justice"])

      get :index

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  describe "GET section" do
    before do
      content_api_has_root_sections(["crime-and-justice"])
    end

    it "404 if the section does not exist" do
      api_returns_404_for("/tags/banana.json")
      api_returns_404_for("/tags.json?parent_id=banana&type=section")

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
      content_api_has_section("crime-and-justice")
      content_api_has_subsections("crime-and-justice", ["alpha"])

      get :top_level_browse_page, top_level_slug: "crime-and-justice"

      assert_equal "browse",  response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      content_api_has_section("crime-and-justice")
      content_api_has_subsections("crime-and-justice", ["alpha"])

      get :top_level_browse_page, top_level_slug: "crime-and-justice"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  describe "GET sub_section" do
    before do
      RelatedTopicList.any_instance.stubs(:related_topics_for).returns([])
      BrowsePageContentItem.any_instance.stubs(:curated_links?).returns(false)

      content_api_has_tag("section", "crime-and-justice")
      content_api_has_tag("section", "crime-and-justice/judges")
      content_api_has_root_tags("section", ["crime-and-justice"])
      content_api_has_child_tags("section", "crime-and-justice", ["judges"])
      content_api_has_artefacts_with_a_tag("section", "crime-and-justice/judges", ["judge-dredd"])
    end

    it "ignores query parameters when requesting related topics" do
      RelatedTopicList.any_instance.expects(:related_topics_for).with("/browse/crime-and-justice/judges").returns(
        [OpenStruct.new(title: 'A Related Topic', web_url: 'https://www.gov.uk/benefits/related')]
      )

      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "judges", :foo => "bar"
    end

    it "404 if the section does not exist" do
      api_returns_404_for("/tags/crime-and-justice%2Ffrume.json")
      api_returns_404_for("/tags/crime-and-justice.json")

      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "frume"

      assert_response 404
    end

    it "return a cacheable 404 without calling content_api if the section slug is invalid" do
      get :second_level_browse_page, top_level_slug: "this & that", second_level_slug: "foo"

      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end

    it "404 if the sub section does not exist" do
      api_returns_404_for("/tags/crime-and-justice%2Ffrume.json")

      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "frume"

      assert_response 404
    end

    it "return a cacheable 404 without calling content_api if the sub section slug is invalid" do
      get :second_level_browse_page, top_level_slug: "foo", second_level_slug: "this & that"

      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end

    it "set slimmer format of browse" do
      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "judges"

      assert_equal "browse",  response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      get :second_level_browse_page, top_level_slug: "crime-and-justice", second_level_slug: "judges"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end
end
