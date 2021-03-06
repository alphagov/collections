RSpec.describe OrganisationsApiController do
  include OrganisationsApiTestHelper
  include SearchApiHelpers
  describe "GET index" do
    before do
      stub_search(params: organisations_params, body: search_api_organisations_results)
      paginated = organisations_params(start: "20")
      stub_search(params: paginated, body: search_api_organisations_many_results)
    end

    it "renders JSON" do
      get :index, format: :json
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body["results"].count).to eq(2)
      expect(body["results"][1]["title"]).to eq("HM Revenue & Customs")
    end

    it "paginates the results" do
      get :index, format: :json
      body = JSON.parse(response.body)

      expect(body["current_page"]).to eq(1)
      expect(body["_response_info"]["status"]).to eq("ok")
    end

    it "sets the Link HTTP header" do
      get :index, format: :json, params: { page: 2 }
      link = "<http://test.host/api/organisations?page=1>; rel=\"previous\", <http://test.host/api/organisations?page=3>; rel=\"next\", <http://test.host/api/organisations?page=2>; rel=\"self\""
      expect(response.headers["Link"]).to eq(link)
    end
  end

  describe "GET show" do
    before do
      hmrc = organisation_params(slug: "hm-revenue-customs")
      stub_search(params: hmrc, body: search_api_organisation_results)

      something_else = organisation_params(slug: "something-else")
      stub_search(params: something_else, body: search_api_organisation_no_results)
    end

    it "renders JSON" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body["title"]).to eq("HM Revenue & Customs")
    end

    it "does not paginate the results" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json
      body = JSON.parse(response.body)

      expect(body["current_page"]).to be_nil
    end

    it "sets the Link HTTP header" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json
      link = "<http://test.host/api/organisations/hm-revenue-customs>; rel=\"self\""
      expect(response.headers["Link"]).to eq(link)
    end

    it "adds _response_info" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json
      body = JSON.parse(response.body)

      expect(body["_response_info"]["status"]).to eq("ok")
    end

    it "renders a 404 error if the organisation is not found" do
      get :show, params: { organisation_name: "something-else" }, format: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
