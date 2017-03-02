require "test_helper"

describe SubtopicsController do

  include GovukAbTesting::MinitestHelpers

  describe "GET subtopic" do
    describe "with a valid topic and subtopic slug" do
      setup do
        stub_services_for_subtopic("content-id-for-wells", "oil-and-gas", "wells")
      end

      it "sets expiry headers for 30 minutes" do
        get :show, topic_slug: "oil-and-gas", subtopic_slug: "wells"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET subtopic with an invalid subtopic tag" do
      content_store_does_not_have_item("/topic/oil-and-gas/coal")

      get :show, topic_slug: "oil-and-gas", subtopic_slug: "coal"

      assert_equal 404, response.status
    end

    describe "during the education navigation A/B test" do
      before do
        stub_services_for_subtopic(
          "content-id-for-apprenticeships",
          "further-education-skills",
          "apprenticeships")
      end

      describe "with the feature flag off" do
        ["A", "B"].each do |variant|
          it "returns the original version of the page for variant #{variant}" do
            setup_ab_variant("EducationNavigation", variant)

            get :show, topic_slug: "further-education-skills", subtopic_slug: "apprenticeships"

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end
      end

      describe "with the feature flag on" do
        it "returns the original version of the page as the A variant" do
          with_A_variant do
            get :show, topic_slug: "further-education-skills", subtopic_slug: "apprenticeships"

            assert_response 200
          end
        end

        it "redirects to the taxonomy navigation as the B variant" do
          with_B_variant assert_meta_tag: false do
            get :show, topic_slug: "further-education-skills", subtopic_slug: "apprenticeships"

            assert_response 302
            assert_redirected_to controller: "taxons",
              action: "show",
              taxon_base_path: "education/apprenticeships-traineeships-and-internships"
          end
        end

        ["A", "B"].each do |variant|
          it "does not change a page outside the A/B test when the #{variant} variant is requested" do
            ClimateControl.modify(ENABLE_NEW_NAVIGATION: 'yes') do
              stub_services_for_subtopic("content-id-for-wells", "oil-and-gas", "wells")

              setup_ab_variant("EducationNavigation", variant)

              get :show, topic_slug: "oil-and-gas", subtopic_slug: "wells"

              assert_response 200
              assert_response_not_modified_for_ab_test
            end
          end
        end
      end
    end
  end

  def stub_services_for_subtopic(content_id, parent_path, path)
    content_store_has_item(
      "/topic/#{parent_path}/#{path}",
      content_item_for_base_path("/topic/#{parent_path}/#{path}").merge(
        "content_id" => content_id,
        "links" => {
          "parent" => [{
            "title" => "Parent Topic Title",
            "base_path" => "/#{parent_path}",
          }],
        }),
    )

    ListSet.stubs(:new).returns(
      [ListSet::List.new("test", [])]
    )

    Services.rummager.stubs(:search).with(
      count: "0",
      filter_topic_content_ids: [content_id],
      facet_organisations: "1000",
    ).returns(
      rummager_has_specialist_sector_organisations("#{parent_path}/#{path}"))
  end
end
