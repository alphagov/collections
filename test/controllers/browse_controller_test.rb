require "test_helper"

describe BrowseController do
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
end
