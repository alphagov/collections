RSpec.describe SecondLevelBrowsePageController do
  include SearchApiHelpers
  include GovukAbTesting::RspecHelpers
  render_views

  describe "GET second_level_browse_page" do
    describe "for a valid browse page" do
      before do
        stub_content_store_has_item(
          "/browse/benefits/entitlement",
          content_id: "entitlement-content-id",
          title: "Entitlement",
          base_path: "/browse/benefits/entitlement",
          links: {
            top_level_browse_pages:,
            second_level_browse_pages:,
            active_top_level_browse_page: [{
              content_id: "content-id-for-benefits",
              title: "Benefits",
              base_path: "/browse/benefits",
            }],
            related_topics: [{ title: "A linked topic", base_path: "/browse/linked-topic" }],
          },
        )

        search_api_has_documents_for_browse_page(
          "entitlement-content-id",
          %w[entitlement],
          page_size: 1000,
        )
      end

      let :params do
        {
          top_level_slug: "benefits",
          second_level_slug: "entitlement",
        }
      end

      it "set correct expiry headers" do
        get :show, params: params
        expect(response.headers["Cache-Control"]).to eq("max-age=300, public")
      end

      it "responds to html by default" do
        get :show, params: params
        expect(response.content_type).to eq "text/html; charset=utf-8"
        expect(response).to render_template(partial: "_links")
      end
    end

    context "AB test: Second level browse pages showing accordions or lists" do
      render_views

      let :params do
        {
          top_level_slug: "benefits",
          second_level_slug: "entitlement",
        }
      end

      subject { get :show, params: }

      before do
        stub_content_store_has_item(
          "/browse/benefits/entitlement",
          content_id: "entitlement-content-id",
          title: "Entitlement",
          base_path: "/browse/benefits/entitlement",
          links: {
            top_level_browse_pages:,
            second_level_browse_pages:,
            active_top_level_browse_page: [{
              content_id: "content-id-for-benefits",
              title: "Benefits",
              base_path: "/browse/benefits",
            }],
            related_topics: [{ title: "A linked topic", base_path: "/browse/linked-topic" }],
          },
          details:,
        )

        search_api_has_documents_for_browse_page(
          "entitlement-content-id",
          %w[entitlement],
          page_size: 1000,
        )
      end
    end

    it "404 if the section does not exist" do
      stub_content_store_does_not_have_item("/browse/crime-and-justice/frume")
      params = {
        top_level_slug: "crime-and-justice",
        second_level_slug: "frume",
      }
      get :show, params: params
      expect(response).to have_http_status(:not_found)
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
