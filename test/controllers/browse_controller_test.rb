require "test_helper"

describe BrowseController do
  include GovukAbTesting::MinitestHelpers

  describe "GET index" do
    before do
      stub_content_store_has_item(
        "/browse",
        links: {
          top_level_browse_pages: top_level_browse_pages,
        },
      )
    end

    it "set correct expiry headers" do
      get :index

      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end

  describe "GET top_level_browse_page" do
    describe "for a valid browse page" do
      before do
        stub_content_store_has_item(
          "/browse/benefits",
          base_path: "/browse/benefits",
          links: {
            top_level_browse_pages: top_level_browse_pages,
            second_level_browse_pages: second_level_browse_pages,
          },
        )
      end

      it "sets correct expiry headers" do
        get :show, params: { top_level_slug: "benefits" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "404 if the browse page does not exist" do
      stub_content_store_does_not_have_item("/browse/banana")

      get :show, params: { top_level_slug: "banana" }

      assert_response 404
    end
  end

  describe "Check correct behaviour of CookielessAATest" do
    before do
      stub_content_store_has_item(
        "/browse",
        links: {
          top_level_browse_pages: top_level_browse_pages,
        },
      )
    end

    %w[A B].each do |test_variant|
      it "record hit when in variant #{test_variant}" do
        with_variant CookielessAATest: test_variant.to_s do
          get :index
          assert_select "meta[data-module=track-variant][content=#{test_variant}]"
        end
      end
    end

    it "not record hit when in variant Z" do
      with_variant CookielessAATest: "Z" do
        get :index
        assert_select "meta[data-module=track-variant]", false
      end
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
