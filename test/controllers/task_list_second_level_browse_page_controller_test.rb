require "test_helper"

describe SecondLevelBrowsePageController do
  include RummagerHelpers
  include GovukAbTesting::MinitestHelpers

  describe "TaskListSidebar A/B test content" do
    before do
      setup_content_for('learning-to-drive')
      setup_content_for('driving-licences')
      setup_content_for('vegetable-sales')
    end

    describe "when in A variant" do
      %w(driving-licences learning-to-drive).each do |slug|
        it "should not display a link to the 'learn to drive' tasklist link in #{slug}" do
          with_variant TaskListBrowse: 'A' do
            get(
              :show,
              params: {
                top_level_slug: "driving",
                second_level_slug: slug
              }
            )

            assert_response 200
            refute_includes @response.body, 'Learn to drive a car: step by step'
          end
        end
      end
    end

    describe "when in B variant" do
      %w(driving-licences learning-to-drive).each do |slug|
        it "should display a link to the 'learn to drive' tasklist link in #{slug}" do
          with_variant TaskListBrowse: 'B' do
            get(
              :show,
              params: {
                top_level_slug: "driving",
                second_level_slug: slug
              }
            )

            assert_response 200
            assert_includes @response.body, 'Learn to drive a car: step by step'
          end
        end
      end
    end

    describe "with irrelevant pages" do
      %w(A B).each do |variant|
        it "should not display a link to learning to drive in variant #{variant}" do
          with_variant TaskListBrowse: variant, assert_meta_tag: false do
            get(
              :show,
              params: {
                top_level_slug: "driving",
                second_level_slug: "vegetable-sales"
              }
            )

            assert_response 200
            refute_includes @response.body, 'Learn to drive a car: step by step'
          end
        end
      end
    end

    def setup_content_for(slug)
      contents = [
        "/apply-first-provisional-driving-licence",
        "/book-theory-test",
        "/book-driving-test",
        "/change-driving-test",
        "/check-driving-test"
      ]

      content_store_has_item(
        "/browse/driving/#{slug}",
        content_id: "#{slug}-id",
        links: {
          active_top_level_browse_page: [{
            title: slug,
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
        "#{slug}-id",
        [slug] + contents.map { |path| path [1..-1] },
        page_size: 1000
      )
    end
  end
end
