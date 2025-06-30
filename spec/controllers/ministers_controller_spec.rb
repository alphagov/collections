RSpec.describe MinistersController do
  def ministers
    GovukSchemas::Example.find("ministers_index", example_name: "ministers_index-reshuffle-mode-off")
  end

  let(:base_path) { ministers["base_path"] }

  describe "index" do
    context "the request is for content store" do
      before do
        stub_content_store_has_item(base_path, ministers)
      end

      it "when the content item exists" do
        get :index, params: { graphql: false }

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    context "the request is for graphql" do
      context "and the graphql query is successful" do
        before do
          stub_publishing_api_graphql_query(
            Graphql::MinistersIndexQuery.new("/government/ministers").query,
            edition_data,
          )
        end

        let(:edition_data) do
          fetch_graphql_fixture("ministers_index-reshuffle-mode-off")
        end

        it "the request is successful" do
          get :index, params: { graphql: true }

          expect(request.env["govuk.prometheus_labels"]).to include({
            "graphql_status_code" => 200,
            "graphql_contains_errors" => false,
            "graphql_api_timeout" => false,
          })
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
        end
      end

      context "and the graphql query is not successful" do
        before do
          stub_publishing_api_graphql_query(
            Graphql::MinistersIndexQuery.new("/government/ministers").query,
            { "errors": [{ "message": "some_error" }] },
          )
          stub_content_store_has_item(base_path, ministers)
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
          stub_content_store_has_item(base_path, ministers)
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

          stub_content_store_has_item(base_path, ministers)
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
end
