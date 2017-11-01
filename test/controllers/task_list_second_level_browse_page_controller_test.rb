require "test_helper"

describe SecondLevelBrowsePageController do
  include RummagerHelpers
  include GovukAbTesting::MinitestHelpers

  describe "TaskListSidebar A/B test content" do
    before do
      contents = [
        "/apply-first-provisional-driving-licence",
        "/book-theory-test",
        "/book-driving-test",
        "/change-driving-test",
        "/check-driving-test"
      ]

      content_store_has_item(
        "/browse/driving/learning-to-drive",
        content_id: 'learning-to-drive-id',
        links: {
          active_top_level_browse_page: [{
            title: 'Learning to drive',
          }],
          second_level_browse_pages: [
            {
              "content-id": 'content-id',
              "title": "title-content-id",
              "base_path": '/browse/content-id'
            }
          ]
        },
        details: {
          second_level_ordering: "curated",
          groups: [
            {
              "name": "Popular services",
              "contents": contents
            },
          ]
        }
      )

      rummager_has_documents_for_browse_page(
        "learning-to-drive-id",
        ["learning-to-drive"] + contents.map { |path| path [1..-1] },
        page_size: 1000
      )
    end

    describe "when in A variant" do
      it "should not display a link to the 'learn to drive' tasklist link" do
        with_variant TaskListSidebar: 'A' do
          get(
            :show,
            params: {
              top_level_slug: "driving",
              second_level_slug: "learning-to-drive"
            }
          )

          assert_response 200
          refute_includes @response.body, 'Learn to drive a car: step by step'
        end
      end
    end

    describe "when in B variant" do
      it "should display a link to the 'learn to drive' tasklist link" do
        with_variant TaskListSidebar: 'B' do
          get(
            :show,
            params: {
              top_level_slug: "driving",
              second_level_slug: "learning-to-drive"
            }
          )

          assert_response 200
          assert_includes @response.body, 'Learn to drive a car: step by step'
        end
      end
    end
  end
end
