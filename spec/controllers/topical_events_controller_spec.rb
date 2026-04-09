RSpec.describe TopicalEventsController do
  let(:example_document) { GovukSchemas::Example.find("topical_event", example_name: "ebola-virus-government-response") }
  let(:base_path) { example_document["base_path"] }
  let(:slug) { base_path.split("/").last }

  describe "GET show" do
    context "the request is for a valid content item" do
      before do
        stub_conditional_loader_returns_content_item_for_path(base_path, example_document)
      end

      it "the request is successful" do
        get :show, params: { name: slug }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
    end

    context "the request is for an invalid content item" do
      before do
        stub_conditional_loader_does_not_return_content_item_for_path("/government/topical-events/invalid")
      end

      it "when there is no content item" do
        get :show, params: { name: "invalid" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
