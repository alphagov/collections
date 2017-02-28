require "test_helper"

describe BrowseController do
  include GovukAbTesting::MinitestHelpers
  include NavigationAbTestHelpers

  describe "GET index" do
    before do
      content_store_has_item("/browse",
        links: {
          top_level_browse_pages: top_level_browse_pages
        }
      )
    end

    it "set correct expiry headers" do
      get :index

      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    it "tracks the page as a 'finding' page type" do
      get :index

      assert_user_journey_stage_tracked_as_finding_page
    end
  end

  describe "GET top_level_browse_page" do
    describe "for a valid browse page" do
      before do
        content_store_has_item("/browse/benefits",
          base_path: '/browse/benefits',
          links: {
            top_level_browse_pages: top_level_browse_pages,
            second_level_browse_pages: second_level_browse_pages,
          }
        )
      end

      it "sets correct expiry headers" do
        get :show, top_level_slug: "benefits"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      it "tracks the page as a 'finding' page type" do
        get :show, top_level_slug: "benefits"

        assert_user_journey_stage_tracked_as_finding_page
      end
    end

    describe "during the education navigation A/B test" do
      before do
        content_store_has_item("/browse/education", base_path: '/browse/education')
        content_store_has_item("/browse/benefits", base_path: '/browse/benefits')
      end

      describe 'with the feature flag off' do
        %w(A B).each do |variant|
          it "returns the original version of the page for variant #{variant}" do
            setup_ab_variant("EducationNavigation", variant)

            get :show, top_level_slug: "education"

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end
      end

      describe "with the feature flag on" do
        it "redirects for variant B" do
          with_B_variant assert_meta_tag: false do
            get :show, top_level_slug: "education"

            assert_redirected_to(
              controller: "taxons",
              action: "show",
              taxon_base_path: "education"
            )
          end
        end

        %w(A B).each do |variant|
          it "does not change a page outside the A/B test when the #{variant} variant is requested" do
            setup_ab_variant("EducationNavigation", variant)

            ClimateControl.modify(ENABLE_NEW_NAVIGATION: 'yes') do
              get :show, top_level_slug: "benefits"
            end

            assert_response 200
            assert_response_not_modified_for_ab_test
          end

          it "does not redirect education when the #{variant} variant is requested in JSON format" do
            setup_ab_variant("EducationNavigation", variant)

            ClimateControl.modify(ENABLE_NEW_NAVIGATION: 'yes') do
              get :show, format: :json, top_level_slug: "education"
            end

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end

        it "returns the original version of the page for variant A" do
          with_A_variant do
            get :show, top_level_slug: "education"

            assert_response 200
          end
        end
      end
    end

    it "404 if the browse page does not exist" do
      content_store_does_not_have_item("/browse/banana")

      get :show, top_level_slug: "banana"

      assert_response 404
    end
  end

  def top_level_browse_pages
    [
      {
        content_id: 'content-id-for-crime-and-justice',
        title: 'Crime and justice',
        base_path: '/browse/crime-and-justice'
      },
      {
        content_id: 'content-id-for-benefits',
        title: 'Benefits',
        base_path: '/browse/benefits'
      },
    ]
  end

  def second_level_browse_pages
    [{
      content_id: 'entitlement-content-id',
      title: 'Entitlement',
      base_path: '/browse/benefits/entitlement'
    }]
  end
end
