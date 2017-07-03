require "test_helper"

describe TopicsController do
  include RummagerHelpers

  include GovukAbTesting::MinitestHelpers

  describe "GET topic" do
    describe "with a valid topic slug" do
      before do
        content_store_has_item('/topic/oil-and-gas', topic_example)
      end

      it "sets expiry headers for 30 minutes" do
        get :show, params: { topic_slug: "oil-and-gas" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET topic with an invalid sector tag" do
      content_store_does_not_have_item("/topic/oil-and-gas")
      get :show, params: { topic_slug: "oil-and-gas" }

      assert_equal 404, response.status
    end
  end

  describe "during the education navigation A/B test" do

    before do
      content_store_has_item('/topic/further-education-skills', topic_example)
    end

    it "returns the original version of the page as the A variant" do
      with_A_variant assert_meta_tag: false do
        get :show, params: { topic_slug: "further-education-skills" }

        assert_response 200
      end
    end

    it "redirects to the taxonomy navigation as the B variant" do
      with_B_variant assert_meta_tag: false do
        get :show, params: { topic_slug: "further-education-skills" }

        assert_redirected_to controller: "taxons",
          action: "show",
          taxon_base_path: "education/further-and-higher-education-skills-and-vocational-training"
      end
    end

    ["A", "B"].each do |variant|
      it "does not change a page outside the A/B test when the #{variant} variant is requested" do
        content_store_has_item('/topic/oil-and-gas', topic_example)
        setup_ab_variant("EducationNavigation", variant)

        get :show, params: { topic_slug: "oil-and-gas" }

        assert_response 200
        assert_response_not_modified_for_ab_test("EducationNavigation")
      end
    end
  end

  def topic_example
    GovukSchemas::Example.find('topic', example_name: 'topic')
  end
end
