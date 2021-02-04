require "test_helper"

describe OrganisationsApiController do
  describe "GET index" do
    setup do
      Services.search_api.stubs(:search).with(
        filter_format: "organisation",
        order: "title",
        count: 20,
        start: 0,
      ).returns(rummager_organisations_results)

      Services.search_api.stubs(:search).with(
        filter_format: "organisation",
        order: "title",
        count: 20,
        start: 20,
      ).returns(rummager_organisations_many_results)
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
      Services.search_api.stubs(:search).with(
        filter_format: "organisation",
        filter_slug: "hm-revenue-customs",
        count: 1,
        start: 0,
      ).returns(rummager_organisation_results)

      Services.search_api.stubs(:search).with(
        filter_format: "organisation",
        filter_slug: "something-else",
        count: 1,
        start: 0,
      ).returns(rummager_organisation_no_results)
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

  def rummager_organisations_results
    {
      results: [
        {
          description: "Established to disrupt organised criminal enterprises through the recovery of criminal assets, and which aims to promote financial investigation as a part of criminal investigation. The Agency ceased to exist on 1 April 2008",
          format: "organisation",
          link: "/government/organisations/assets-recovery-agency",
          organisations: [
            {
              logo_formatted_title: "Assets Recovery Agency",
              organisation_crest: "single-identity",
              title: "Closed organisation: Assets Recovery Agency",
              content_id: "01046836-de95-43aa-9b36-941e705bcdf4",
              link: "/government/organisations/assets-recovery-agency",
              slug: "assets-recovery-agency",
              analytics_identifier: "EA698",
              public_timestamp: "2014-10-15T15:37:20.000+01:00",
              organisation_type: "executive_agency",
              organisation_closed_state: "no_longer_exists",
              organisation_state: "closed",
            },
          ],
          public_timestamp: "2014-10-15T15:37:20.000+01:00",
          slug: "assets-recovery-agency",
          title: "Closed organisation: Assets Recovery Agency",
          index: "government",
          es_score: nil,
          _id: "/government/organisations/assets-recovery-agency",
          elasticsearch_type: "edition",
          document_type: "edition",
        },
        {
          description: "The home of HM Revenue & Customs on GOV.UK. We are the UK’s tax, payments and customs authority, and we have a vital purpose: we collect the money that pays for the UK’s public services and help families and individuals with targeted financial support. We do this by being impartial and increasingly effective and efficient in our administration. We help the honest majority to get their tax right and make it hard for the dishonest minority to cheat the system.",
          format: "organisation",
          link: "/government/organisations/hm-revenue-customs",
          organisations: [
            {
              organisation_crest: "hmrc",
              superseded_organisations: %w[
                department-of-inland-revenue
              ],
              acronym: "HMRC",
              link: "/government/organisations/hm-revenue-customs",
              analytics_identifier: "D25",
              public_timestamp: "2015-05-13T11:09:06.000+01:00",
              child_organisations: [
                "valuation-office-agency",
                "the-adjudicator-s-office",
              ],
              organisation_brand: "hm-revenue-customs",
              logo_formatted_title: "HM Revenue\r\n& Customs",
              title: "HM Revenue & Customs",
              content_id: "6667cce2-e809-4e21-ae09-cb0bdc1ddda3",
              slug: "hm-revenue-customs",
              organisation_type: "non_ministerial_department",
              organisation_state: "live",
            },
          ],
          public_timestamp: "2015-05-13T11:09:06.000+01:00",
          slug: "hm-revenue-customs",
          title: "HM Revenue & Customs",
          index: "government",
          es_score: nil,
          _id: "/government/organisations/hm-revenue-customs",
          elasticsearch_type: "edition",
          document_type: "edition",
        },
      ],
      total: 2,
      start: 0,
    }.deep_stringify_keys
  end

  def rummager_organisations_many_results
    {
      results: [],
      total: 1000,
      start: 0,
    }.deep_stringify_keys
  end

  def rummager_organisation_results
    {
      results: [
        {
          description: "The home of HM Revenue & Customs on GOV.UK. We are the UK’s tax, payments and customs authority, and we have a vital purpose: we collect the money that pays for the UK’s public services and help families and individuals with targeted financial support. We do this by being impartial and increasingly effective and efficient in our administration. We help the honest majority to get their tax right and make it hard for the dishonest minority to cheat the system.",
          format: "organisation",
          link: "/government/organisations/hm-revenue-customs",
          organisations: [
            {
              organisation_crest: "hmrc",
              superseded_organisations: %w[
                department-of-inland-revenue
              ],
              acronym: "HMRC",
              link: "/government/organisations/hm-revenue-customs",
              analytics_identifier: "D25",
              public_timestamp: "2015-05-13T11:09:06.000+01:00",
              child_organisations: [
                "valuation-office-agency",
                "the-adjudicator-s-office",
              ],
              organisation_brand: "hm-revenue-customs",
              logo_formatted_title: "HM Revenue\r\n& Customs",
              title: "HM Revenue & Customs",
              content_id: "6667cce2-e809-4e21-ae09-cb0bdc1ddda3",
              slug: "hm-revenue-customs",
              organisation_type: "non_ministerial_department",
              organisation_state: "live",
            },
          ],
          public_timestamp: "2015-05-13T11:09:06.000+01:00",
          slug: "hm-revenue-customs",
          title: "HM Revenue & Customs",
          index: "government",
          es_score: nil,
          _id: "/government/organisations/hm-revenue-customs",
          elasticsearch_type: "edition",
          document_type: "edition",
        },
      ],
      total: 1,
      start: 0,
    }.deep_stringify_keys
  end

  def rummager_organisation_no_results
    {
      results: [],
      total: 0,
      start: 0,
    }.deep_stringify_keys
  end
end
