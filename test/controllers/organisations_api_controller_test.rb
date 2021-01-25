require "test_helper"

describe OrganisationsApiController do
  include OrganisationsApiTestHelper
  describe "GET index" do
    setup do
      Services.search_api.stubs(:search)
      .with(organisations_params)
      .returns(search_api_organisations_results)

      Services.search_api.stubs(:search)
      .with(organisations_params(start: 20))
      .returns(search_api_organisations_many_results)
    end

    it "renders JSON" do
      get :index, format: :json
      assert_equal 200, response.status

      body = JSON.parse(response.body)
      assert_equal 2, body["results"].count
      assert_equal "HM Revenue & Customs", body["results"][1]["title"]
    end

    it "paginates the results" do
      get :index, format: :json
      body = JSON.parse(response.body)

      assert_equal 1, body["current_page"]
      assert_equal "ok", body["_response_info"]["status"]
    end

    it "sets the Link HTTP header" do
      get :index, format: :json, params: { page: 2 }

      assert_equal '<http://test.host/api/organisations?page=1>; rel="previous", <http://test.host/api/organisations?page=3>; rel="next", <http://test.host/api/organisations?page=2>; rel="self"', response.headers["Link"]
    end
  end

  describe "GET show" do
    setup do
      Services.search_api.stubs(:search)
      .with(organisation_params(slug: "hm-revenue-customs"))
      .returns(search_api_organisation_results)

      Services.search_api.stubs(:search)
      .with(organisation_params(slug: "something-else"))
      .returns(search_api_organisation_no_results)
    end

    it "renders JSON" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json
      assert_equal 200, response.status

      body = JSON.parse(response.body)
      assert_equal "HM Revenue & Customs", body["title"]
    end

    it "does not paginate the results" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json
      body = JSON.parse(response.body)

      assert_nil body["current_page"]
    end

    it "sets the Link HTTP header" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json

      assert_equal '<http://test.host/api/organisations/hm-revenue-customs>; rel="self"', response.headers["Link"]
    end

    it "adds _response_info" do
      get :show, params: { organisation_name: "hm-revenue-customs" }, format: :json
      body = JSON.parse(response.body)

      assert_equal "ok", body["_response_info"]["status"]
    end

    it "renders a 404 error if the organisation is not found" do
      get :show, params: { organisation_name: "something-else" }, format: :json
      assert_equal 404, response.status
    end
  end
end
