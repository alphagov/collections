require "test_helper"

describe SecondLevelBrowsePageController do
  include RummagerHelpers
  include GovukAbTesting::MinitestHelpers
  include NavigationAbTestHelpers

  describe "GET second_level_browse_page" do
    describe "for a valid browse page" do
      before do
        content_store_has_item("/browse/benefits/entitlement",
          content_id: 'entitlement-content-id',
          title: 'Entitlement',
          base_path: '/browse/benefits/entitlement',
          links: {
            top_level_browse_pages: top_level_browse_pages,
            second_level_browse_pages: second_level_browse_pages,
            active_top_level_browse_page: [{
              content_id: 'content-id-for-benefits',
              title: 'Benefits',
              base_path: '/browse/benefits'
            }],
            related_topics: [{ title: 'A linked topic', base_path: '/browse/linked-topic' }]
          }
        )

        rummager_has_documents_for_browse_page(
          "entitlement-content-id",
          ["entitlement"],
          page_size: 1000
        )
      end

      it "set correct expiry headers" do
        get :show, top_level_slug: "benefits", second_level_slug: "entitlement"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      it "tracks the page as a 'finding' page type" do
        get :show, top_level_slug: "benefits", second_level_slug: "entitlement"

        assert_user_journey_stage_tracked_as_finding_page
      end
    end

    describe "during the education navigation A/B test" do
      before do
        content_store_has_item("/browse/education/student-finance",
          content_id: 'student-finance-content-id',
          links: {
            active_top_level_browse_page: [{
              title: 'Education and learning',
            }],
          }
        )

        rummager_has_documents_for_browse_page(
          "student-finance-content-id",
          ["student-finance"],
          page_size: 1000
        )
      end

      describe "with the feature flag off" do
        %w(A, B).each do |variant|
          it "returns the original version of the page for variant #{variant}" do
            setup_ab_variant("EducationNavigation", variant)

            get :show, top_level_slug: "education", second_level_slug: "student-finance"

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end
      end

      describe "with the feature flag on" do
        it "returns the original version of education pages as the A variant" do
          with_A_variant do
            get :show, top_level_slug: "education", second_level_slug: "student-finance"

            assert_response 200
          end
        end

        it "redirects to the taxonomy navigation as the B variant" do
          with_B_variant assert_meta_tag: false do
            get :show, top_level_slug: "education", second_level_slug: "student-finance"

            assert_response 302
            assert_redirected_to controller: "taxons", action: "show",
              taxon_base_path: "education/funding-and-finance-for-students"
          end
        end

        it "redirects page with no specific taxon to the top-level education taxon" do
          content_store_has_item("/browse/education/school-life",
            content_id: 'school-life-content-id',
            links: {
              active_top_level_browse_page: [{
                title: 'Education and learning',
              }],
            }
          )

          rummager_has_documents_for_browse_page(
            "school-life-content-id",
            ["school-life"],
            page_size: 1000
          )

          with_B_variant assert_meta_tag: false do
            get :show, top_level_slug: "education", second_level_slug: "school-life"

            assert_response 302
            assert_redirected_to controller: "taxons", action: "show", taxon_base_path: "education"
          end
        end

        %w(A, B).each do |variant|
          it "does not redirect pages outside of education in the #{variant} variant" do
            content_store_has_item("/browse/benefits/entitlement",
              content_id: 'entitlement-content-id',
              links: {
                active_top_level_browse_page: [{
                  title: 'Benefits',
                }],
              }
            )

            rummager_has_documents_for_browse_page(
              "entitlement-content-id",
              ["entitlement"],
              page_size: 1000
            )

            setup_ab_variant("EducationNavigation", variant)
            get :show, top_level_slug: "benefits", second_level_slug: "entitlement"

            assert_response 200
            assert_response_not_modified_for_ab_test
          end

          it "does not redirect education when the #{variant} variant is requested in JSON format" do
            setup_ab_variant("EducationNavigation", variant)

            get :show, top_level_slug: "education", second_level_slug: "student-finance", format: :json

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end
      end
    end

    it "404 if the section does not exist" do
      content_store_does_not_have_item("/browse/crime-and-justice/frume")

      get :show, top_level_slug: "crime-and-justice", second_level_slug: "frume"

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
