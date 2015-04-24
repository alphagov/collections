require "test_helper"

describe BrowseController do
  describe "GET index" do
    it "list all categories" do
      content_api_has_root_sections(["crime-and-justice"])
      get :index
      assert_select "a[href=/browse/crime-and-justice]", "Crime and justice"
    end

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

    it "list the sub sections" do
      content_api_has_root_sections(["crime-and-justice"])
      content_api_has_section("crime-and-justice")
      content_api_has_subsections("crime-and-justice", ["alpha"])
      get :section, section: "crime-and-justice"

      assert_select "h1", "Crime and justice"
      assert_select "a[href=/browse/alpha]"
    end

    it "404 if the section does not exist" do
      api_returns_404_for("/tags/banana.json")
      api_returns_404_for("/tags.json?parent_id=banana&type=section")

      get :section, section: "banana"
      assert_response 404
    end

    it "return a cacheable 404 without calling content_api if the section slug is invalid" do
      get :section, section: "this & that"
      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]

      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end

    it "set slimmer format of browse" do
      content_api_has_section("crime-and-justice")
      content_api_has_subsections("crime-and-justice", ["alpha"])
      get :section, section: "crime-and-justice"

      assert_equal "browse",  response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      content_api_has_section("crime-and-justice")
      content_api_has_subsections("crime-and-justice", ["alpha"])
      get :section, section: "crime-and-justice"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  describe "GET sub_section" do
    before do
      RelatedTopicList.any_instance.stubs(:related_topics_for).returns([])

      content_api_has_tag("section", "crime-and-justice")
      content_api_has_tag("section", "crime-and-justice/judges")
      content_api_has_root_tags("section", ["crime-and-justice"])
      content_api_has_child_tags("section", "crime-and-justice", ["judges"])
      content_api_has_artefacts_with_a_tag("section", "crime-and-justice/judges", ["judge-dredd"])
    end

    it "list the content in the sub section" do
      get :sub_section, section: "crime-and-justice", sub_section: "judges"

      assert_select "h1", "Judges"
      assert_select "a", "Judge dredd"
    end

    it "lists related topics in the subsection" do
      RelatedTopicList.any_instance.stubs(:related_topics_for).returns(
        [OpenStruct.new(title: 'A Related Topic', web_url: 'https://www.gov.uk/benefits/related')]
      )

      get :sub_section, section: "crime-and-justice", sub_section: "judges"

      assert_select '.detailed-guidance' do
        assert_select "li a[href='https://www.gov.uk/benefits/related']", text: 'A Related Topic'
      end
    end

    it "404 if the section does not exist" do
      api_returns_404_for("/tags/crime-and-justice%2Ffrume.json")
      api_returns_404_for("/tags/crime-and-justice.json")

      get :sub_section, section: "crime-and-justice", sub_section: "frume"
      assert_response 404
    end

    it "return a cacheable 404 without calling content_api if the section slug is invalid" do
      get :sub_section, section: "this & that", sub_section: "foo"
      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]

      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end

    it "404 if the sub section does not exist" do
      api_returns_404_for("/tags/crime-and-justice%2Ffrume.json")

      get :sub_section, section: "crime-and-justice", sub_section: "frume"
      assert_response 404
    end

    it "return a cacheable 404 without calling content_api if the sub section slug is invalid" do
      get :sub_section, section: "foo", sub_section: "this & that"
      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]

      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end

    it "set slimmer format of browse" do
      get :sub_section, section: "crime-and-justice", sub_section: "judges"

      assert_equal "browse",  response.headers["X-Slimmer-Format"]
    end

    it "set correct expiry headers" do
      get :sub_section, section: "crime-and-justice", sub_section: "judges"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end
end
