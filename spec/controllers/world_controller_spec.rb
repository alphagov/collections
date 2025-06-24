RSpec.describe WorldController do
  def world
    GovukSchemas::Example.find("world_index", example_name: "world_index")
  end

  let(:base_path) { world["base_path"] }

  describe "GET index" do
    context "the request is for content store" do
      before do
        stub_content_store_has_item(base_path, world)
      end

      it "successfully renders the page" do
        get :index, params: { graphql: false }

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end
  end

  context "the request is for graphql" do
    context "and the graphql query is successful" do
      before do
        stub_publishing_api_graphql_query(
          Graphql::WorldIndexQuery.new("/world").query,
          edition_data,
        )
      end

      let(:edition_data) do
        fetch_graphql_fixture("world_index")
      end

      it "the request is successful" do
        get :index, params: { graphql: true }

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end
  end
end
