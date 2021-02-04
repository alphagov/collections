require "test_helper"

describe SecondLevelBrowsePageController do
  include SearchApiHelpers

  describe "GET second_level_browse_page" do
    describe "for a valid browse page" do
      before do
        stub_content_store_has_item(
          "/browse/benefits/entitlement",
          content_id: "entitlement-content-id",
          title: "Entitlement",
          base_path: "/browse/benefits/entitlement",
          links: {
            top_level_browse_pages: top_level_browse_pages,
            second_level_browse_pages: second_level_browse_pages,
            active_top_level_browse_page: [{
              content_id: "content-id-for-benefits",
              title: "Benefits",
              base_path: "/browse/benefits",
            }],
            related_topics: [{ title: "A linked topic", base_path: "/browse/linked-topic" }],
          },
        )

        rummager_has_documents_for_browse_page(
          "entitlement-content-id",
          %w[entitlement],
          page_size: 1000,
        )
      end

      it "set correct expiry headers" do
        get(
          :show,
          params: {
            top_level_slug: "benefits",
            second_level_slug: "entitlement",
          },
        )

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "404 if the section does not exist" do
      stub_content_store_does_not_have_item("/browse/crime-and-justice/frume")

      get(
        :show,
        params: {
          top_level_slug: "crime-and-justice",
          second_level_slug: "frume",
        },
      )

      assert_response 404
    end
  end

  def top_level_browse_pages
    [
      {
        content_id: "content-id-for-crime-and-justice",
        title: "Crime and justice",
        base_path: "/browse/crime-and-justice",
      },
      {
        content_id: "content-id-for-benefits",
        title: "Benefits",
        base_path: "/browse/benefits",
      },
    ]
  end

  def second_level_browse_pages
    [{
      content_id: "entitlement-content-id",
      title: "Entitlement",
      base_path: "/browse/benefits/entitlement",
    }]
  end
end
