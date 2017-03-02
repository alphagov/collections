require "test_helper"

describe TopicsController do
  include ContentSchemaHelpers
  include RummagerHelpers
  include NavigationAbTestHelpers

  include GovukAbTesting::MinitestHelpers

  describe "GET topic" do
    describe "with a valid topic slug" do
      before do
        content_store_has_item('/topic/oil-and-gas', content_schema_example(:topic, :topic))
      end

      it "sets expiry headers for 30 minutes" do
        get :show, topic_slug: "oil-and-gas"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      it "tracks the page as a 'finding' page type" do
        get :show, topic_slug: "oil-and-gas"

        assert_user_journey_stage_tracked_as_finding_page
      end
    end

    it "returns a 404 status for GET topic with an invalid sector tag" do
      content_store_does_not_have_item("/topic/oil-and-gas")
      get :show, topic_slug: "oil-and-gas"

      assert_equal 404, response.status
    end
  end

  describe "during the education navigation A/B test" do

    before do
      content_store_has_item('/topic/further-education-skills', content_schema_example(:topic, :topic))
    end

    describe "with the feature flag off" do
      ["A", "B"].each do |variant|
        it "returns the original version of the page for variant #{variant}" do
          setup_ab_variant("EducationNavigation", variant)

          get :show, topic_slug: "further-education-skills"

          assert_response 200
          assert_response_not_modified_for_ab_test
        end
      end
    end

    describe "with the feature flag on" do
      it "returns the original version of the page as the A variant" do
        with_A_variant assert_meta_tag: false do
          get :show, topic_slug: "further-education-skills"

          assert_response 200
        end
      end

      it "redirects to the taxonomy navigation as the B variant" do
        with_B_variant assert_meta_tag: false do
          get :show, topic_slug: "further-education-skills"

          assert_redirected_to controller: "taxons",
            action: "show",
            taxon_base_path: "education/further-and-higher-education-skills-and-vocational-training"
        end
      end

      ["A", "B"].each do |variant|
        it "does not change a page outside the A/B test when the #{variant} variant is requested" do
          ClimateControl.modify(ENABLE_NEW_NAVIGATION: 'yes') do
            content_store_has_item('/topic/oil-and-gas', content_schema_example(:topic, :topic))
            setup_ab_variant("EducationNavigation", variant)

            get :show, topic_slug: "oil-and-gas"

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end
      end
    end
  end
end
