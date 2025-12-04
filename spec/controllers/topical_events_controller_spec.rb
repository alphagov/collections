RSpec.describe TopicalEventsController do
  let(:example_document) { GovukSchemas::Example.find("topical_event", example_name: "ebola-virus-government-response") }
  let(:base_path) { example_document["base_path"] }
  let(:slug) { base_path.split("/").last }

  describe "GET show" do
    context "the request is for content store" do
      before do
        stub_content_store_has_item(base_path, example_document)
        stub_content_store_does_not_have_item("/government/topical-events/invalid")
      end

      it "when the content item exists" do
        get :show, params: { name: slug, graphql: false }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end

      it "when there is no content item" do
        get :show, params: { name: "invalid", graphql: false }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the request is for GraphQL" do
      context "and the GraphQL query is successful" do
        before do
          stub_publishing_api_graphql_has_item(base_path, example_document)
        end

        it "the request is successful" do
          get :show, params: { name: slug, graphql: true }

          expect(request.env["govuk.prometheus_labels"]).to include({
            "graphql_status_code" => 200,
            "graphql_api_timeout" => false,
          })
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)
        end
      end

      context "and publishing-api returns an error status code" do
        before do
          stub_any_publishing_api_call_to_return_not_found
          stub_content_store_has_item(base_path, example_document)
        end

        it "falls back to loading from Content Store" do
          get :show, params: { name: slug, graphql: true }

          expect(response).to have_http_status(:success)
        end

        it "pushes the status codes to prometheus" do
          get :show, params: { name: slug, graphql: true }

          expect(request.env["govuk.prometheus_labels"]["graphql_status_code"]).to eq(404)
        end
      end

      context "and GDS API Adapters times-out the request" do
        before do
          allow(Services.publishing_api).to receive(:graphql_live_content_item)
            .and_raise(GdsApi::TimedOutException)

          stub_content_store_has_item(base_path, example_document)
        end

        it "falls back to loading from Content Store" do
          get :show, params: { name: slug, graphql: true }

          expect(response).to have_http_status(:success)
        end

        it "pushes the errors to prometheus" do
          get :show, params: { name: slug, graphql: true }

          expect(request.env["govuk.prometheus_labels"]["graphql_api_timeout"]).to be(true)
        end
      end
    end
  end
end
