RSpec.describe HistoricAppointmentsController do
  describe "GET show for an individual past foreign secretary" do
    it "has a success response for a past foreign secretary with an individual page" do
      get :show, params: { id: "austen-chamberlain" }
      expect(response).to have_http_status(:success)
    end

    it "responds with a 404 if the requested foreign secretary does not exist" do
      get :show, params: { id: "mr-blobby" }
      expect(response).to have_http_status(:not_found)
    end
  end
end
