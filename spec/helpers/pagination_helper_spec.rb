describe PaginationHelper do
  let(:presented_results) do
    [
      {
        id: "https://www.gov.uk/api/organisations/hm-revenue-customs",
        title: "HM Revenue & Customs",
        format: "Non-ministerial department",
        updated_at: "2015-05-13T11:09:06.000+01:00",
        web_url: "https://www.gov.uk/government/organisations/hm-revenue-customs",
        details: {
          slug: "hm-revenue-customs",
          abbreviation: "HMRC",
          logo_formatted_name: "HM Revenue\r\n& Customs",
          organisation_brand_colour_class_name: "hm-revenue-customs",
          organisation_logo_type_class_name: "hmrc",
          closed_at: nil,
          govuk_status: "live",
          govuk_closed_status: nil,
          content_id: "6667cce2-e809-4e21-ae09-cb0bdc1ddda3",
        },
        analytics_identifier: "D25",
        parent_organisations: [],
        child_organisations: [
          {
            id: "https://www.gov.uk/api/organisations/valuation-office-agency",
            web_url: "https://www.gov.uk/government/organisations/valuation-office-agency",
          },
          {
            id: "https://www.gov.uk/api/organisations/the-adjudicator-s-office",
            web_url: "https://www.gov.uk/government/organisations/the-adjudicator-s-office",
          },
        ],
        superseded_organisations: [
          {
            id: "https://www.gov.uk/api/organisations/department-of-inland-revenue",
            web_url: "https://www.gov.uk/government/organisations/department-of-inland-revenue",
          },
        ],
        superseding_organisations: [],
      },
    ]
  end
  let(:current_page) { 1 }
  let(:results_per_page) { 20 }

  describe "#paginate with wrapped results" do
    let(:total_results) { 21 } # Do this so we get page numbers in the links
    let(:current_url_without_parameters) { "https://www.gov.uk/api/organisations" }

    it "returns a hash with results and pagination details" do
      paginated_results = paginate(presented_results, true)

      expect(paginated_results[:results]).to eq(presented_results)
      expect(paginated_results[:previous_page_url]).to be_nil
      expect(paginated_results[:next_page_url]).to eq("#{current_url_without_parameters}?page=2")
      expect(paginated_results[:current_page]).to eq(current_page)
      expect(paginated_results[:total]).to eq(total_results)
      expect(paginated_results[:pages]).to eq(2)
      expect(paginated_results[:page_size]).to eq(results_per_page)
      expect(paginated_results[:start_index]).to eq(1)
      # next_page_url
      expect(paginated_results[:_response_info][:links][0][:href]).to eq("#{current_url_without_parameters}?page=2")
      # current_page_url
      expect(paginated_results[:_response_info][:links][1][:href]).to eq("#{current_url_without_parameters}?page=1")
    end
  end

  describe "#paginate without wrapped results" do
    let(:total_results) { 1 }
    let(:current_url_without_parameters) { "https://www.gov.uk/api/organisations/hm-revenue-customs" }

    it "returns a hash with results and no pagination details" do
      paginated_results = paginate(presented_results, false)

      expect(paginated_results[:title]).to eq("HM Revenue & Customs")
      expect(paginated_results[:results]).to be_nil
      # current_page_url
      expect(paginated_results[:_response_info][:links][0][:href]).to eq(current_url_without_parameters)
    end
  end
end
