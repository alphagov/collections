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

    context "and the graphql query is not successful" do
      before do
        stub_publishing_api_graphql_query(
          Graphql::WorldIndexQuery.new("/world").query,
          { "errors": [{ "message": "some_error" }] },
        )
        stub_content_store_has_item(base_path, world)
      end

      it "falls back to loading from Content Store" do
        get :index, params: { graphql: true }

        expect(response).to have_http_status(:success)
      end

      it "pushes the errors to prometheus when the response contains some" do
        get :index, params: { graphql: true }

        expect(request.env["govuk.prometheus_labels"]["graphql_contains_errors"]).to be(true)
      end
    end

    context "and publishing-api returns an error status code" do
      before do
        stub_any_publishing_api_call_to_return_not_found
        stub_content_store_has_item(base_path, world)
      end

      it "falls back to loading from Content Store" do
        get :index, params: { graphql: true }

        expect(response).to have_http_status(:success)
      end

      it "pushes the status codes to prometheus" do
        get :index, params: { graphql: true }

        expect(request.env["govuk.prometheus_labels"]["graphql_status_code"]).to eq(404)
      end
    end

    context "and GDS API Adapters times-out the request" do
      before do
        allow(Services.publishing_api).to receive(:graphql_query)
          .and_raise(GdsApi::TimedOutException)

        stub_content_store_has_item(base_path, world)
      end

      it "falls back to loading from Content Store" do
        get :index, params: { graphql: true }

        expect(response).to have_http_status(:success)
      end

      it "pushes the errors to prometheus" do
        get :index, params: { graphql: true }

        expect(request.env["govuk.prometheus_labels"]["graphql_api_timeout"]).to be(true)
      end
    end
  end
end
