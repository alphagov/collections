RSpec.describe PastChancellorsController do
  let(:base_path) { "/government/history/past-chancellors" }
  let(:content_item) do
    {
      base_path:,
      title: "Past Chancellors of the Exchequer",
    }
  end

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  describe "GET index" do
    it "has a success response" do
      get :index

      expect(response).to have_http_status(:success)
    end
  end
end
