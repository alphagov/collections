require_relative "../test_helper"

describe BrowseController do
  before do
    # Stub out the website_root to make sure we are providing a
    # consistent root for the site URL, regardless of environment.
    #
    # The website root is hard-coded in the test helpers, so it gets hard-coded
    # here too.
    Plek.any_instance.stubs(:website_root).returns("http://www.test.gov.uk")
  end

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
      mock_api = stub('guidance_api')
      @results = stub("results", results: [])
      mock_api.stubs(:sub_sections).returns(@results)
      BrowseController.any_instance.stubs(:detailed_guidance_content_api).returns(mock_api)

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

    it "list detailed guidance categories in the sub section" do
      detailed_guidance = OpenStruct.new({
        title: 'Detailed guidance',
        content_with_tag: OpenStruct.new(web_url: 'http://example.com/browse/detailed-guidance')
      })

      @results.stubs(:results).returns([detailed_guidance])

      get :sub_section, section: "crime-and-justice", sub_section: "judges"

      assert_select '.detailed-guidance' do
        assert_select "li a[href='http://example.com/browse/detailed-guidance']", text: 'Detailed guidance'
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
