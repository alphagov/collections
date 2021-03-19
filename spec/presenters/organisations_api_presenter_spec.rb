RSpec.describe OrganisationsApiPresenter do
  let(:results) do
    [
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
      }.deep_stringify_keys,
      {
        description: "The home of the Who Framed Roger Rabbit enquiry",
        format: "organisation",
        link: "/government/organisations/who-framed-roger-rabbit",
        organisations: [
          {
            organisation_crest: "hmrc",
            acronym: "WFRR",
            link: "/government/organisations/who-framed-roger-rabbit",
            analytics_identifier: "D26",
            public_timestamp: "2015-05-13T11:09:06.000+01:00",
            organisation_brand: "hm-revenue-customs",
            logo_formatted_title: "Who Framed\r\nRoger Rabbit",
            title: "Closed organisation: Who Framed Roger Rabbit",
            content_id: "6667cce2-e809-4e21-ae09-cb0bdc1ddda3",
            slug: "hm-revenue-customs",
            organisation_type: "non_ministerial_department",
            organisation_state: "closed",
            organisation_closed_state: "no_longer_exists",
          },
        ],
        public_timestamp: "2015-05-13T11:09:06.000+01:00",
        slug: "who-framed-roger-rabbit",
        title: "Closed organisation: Who Framed Roger Rabbit",
        index: "government",
        es_score: nil,
        _id: "/government/organisations/who-framed-roger-rabbit",
        elasticsearch_type: "edition",
        document_type: "edition",
      }.deep_stringify_keys,
    ]
  end

  let(:presenter_wrapped) do
    OrganisationsApiPresenter.new(
      results,
      current_page: 1,
      results_per_page: 20,
      total_results: 2,
      current_url_without_parameters: "https://www.gov.uk/api/organisations",
    )
  end

  let(:presenter_not_wrapped) do
    OrganisationsApiPresenter.new(
      results,
      current_page: 1,
      results_per_page: 20,
      total_results: 1,
      current_url_without_parameters: "https://www.gov.uk/api/organisations",
      wrap_in_results_array: false,
    )
  end

  describe "#present with wrapped results" do
    it "returns a presented result set" do
      paginated_results = presenter_wrapped.present
      expect(paginated_results[:results][0][:title]).to eq("HM Revenue & Customs")
      expect(paginated_results[:results][0][:details][:slug]).to eq("hm-revenue-customs")
    end

    it "sets the appropriate title for closed orgs" do
      paginated_results = presenter_wrapped.present
      expect(paginated_results[:results][1][:title]).to eq("Who Framed Roger Rabbit")
    end
  end

  describe "#present without wrapped results" do
    it "returns a presented result set" do
      paginated_results = presenter_not_wrapped.present
      expect(paginated_results[:title]).to eq("HM Revenue & Customs")
      expect(paginated_results[:details][:slug]).to eq("hm-revenue-customs")
    end
  end
end
