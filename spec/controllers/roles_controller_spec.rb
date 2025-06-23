RSpec.describe RolesController do
  include SearchApiHelpers

  def prime_minister
    GovukSchemas::Example.find("role", example_name: "prime_minister")
  end

  let(:base_path) { prime_minister["base_path"] }
  let(:role) { base_path.split("/").last }

  describe "GET show" do
    context "the request is for content store" do
      before do
        stub_content_store_has_item(base_path, prime_minister)
        stub_content_store_does_not_have_item("/government/ministers/she-ra")
        stub_minister_announcements(role)
      end

      it "when the content item exists" do
        get :show, params: { name: role }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end

      it "when there is no content item" do
        get :show, params: { name: "she-ra" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the request is for graphql" do
      context "and the graphql query is successful" do
        before do
          stub_publishing_api_graphql_query(
            Graphql::RoleQuery.new("/government/ministers/prime-minister").query,
            role_edition_data,
          )
        end

        let(:role_edition_data) do
          fetch_graphql_fixture("prime_minister")
        end

        it "the request is successful" do
          get :show, params: { name: role, graphql: true }

          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)
        end
      end

      context "and the graphql query is not successful" do
        before do
          stub_publishing_api_graphql_query(
            Graphql::RoleQuery.new("/government/ministers/prime-minister").query,
            { "errors": [{ "message": "some_error" }] },
          )
          stub_content_store_has_item(base_path, prime_minister)
        end

        it "falls back to loading from Content Store" do
          get :show, params: { name: role, graphql: true }

          expect(response).to have_http_status(:success)
        end
      end

      context "and publishing-api returns an error status code" do
        before do
          stub_any_publishing_api_call_to_return_not_found
          stub_content_store_has_item(base_path, prime_minister)
        end

        it "falls back to loading from Content Store" do
          get :show, params: { name: role, graphql: true }

          expect(response).to have_http_status(:success)
        end
      end

      context "and GDS API Adapters times-out the request" do
        before do
          allow(Services.publishing_api).to receive(:graphql_query)
            .and_raise(GdsApi::TimedOutException)

          stub_content_store_has_item(base_path, prime_minister)
        end

        it "falls back to loading from Content Store" do
          get :show, params: { name: role, graphql: true }

          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
