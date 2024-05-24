RSpec.describe BrowseController do
  include GovukAbTesting::RspecHelpers
  render_views
  describe "GET index" do
    before do
      stub_content_store_has_item(
        "/browse",
        links: {
          top_level_browse_pages:,
        },
      )
    end

    it "set correct expiry headers" do
      get :index

      expect(response.headers["Cache-Control"]).to eq("max-age=300, public")
    end

    it "is not included in the newbrowse AB test" do
      assert_response_not_modified_for_ab_test("NewBrowse")
    end
  end

  describe "GET top_level_browse_page" do
    describe "for a valid browse page" do
      before do
        stub_content_store_has_item(
          "/browse/benefits",
          base_path: "/browse/benefits",
          title: "foo",
          links: {
            top_level_browse_pages:,
            second_level_browse_pages:,
          },
        )
      end

      it "sets correct expiry headers" do
        get :show, params: { top_level_slug: "benefits" }
        expect(response.headers["Cache-Control"]).to eq("max-age=300, public")
      end

      it "responds to html by default" do
        get :show, params: { top_level_slug: "benefits" }
        expect(response.content_type).to eq "text/html; charset=utf-8"
        expect(response).to render_template(partial: "_cards")
      end

      context "NewBrowse AB test" do
        subject { get :show, params: { top_level_slug: "benefits" } }

        %w[A B Z].each do |variant|
          it "with variant #{variant}" do
            with_variant NewBrowse: variant do
              expect(subject).to render_template(:show)
            end
          end
        end
      end
    end

    it "404 if the browse page does not exist" do
      stub_content_store_does_not_have_item("/browse/banana")

      get :show, params: { top_level_slug: "banana" }

      expect(response).to have_http_status(404)
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
