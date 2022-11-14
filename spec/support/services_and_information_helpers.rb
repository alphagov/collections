module ServicesAndInformationHelpers
  def stub_services_and_information_content_item
    stub_content_item(
      "/government/organisations/hm-revenue-customs/services-information",
      "HM Revenue & Customs",
    )
  end

  def stub_content_item(base_path, organisation_title)
    stub_content_store_has_item(
      base_path,
      base_path:,
      title: "S&I page title",
      description: "",
      document_type: "services_and_information",
      public_updated_at: 10.days.ago.iso8601,
      details: {},
      links: {
        parent: [
          {
            analytics_identifier: "org_analytics_id",
            base_path: "/organisation/base/path",
            title: organisation_title,
          },
        ],
      },
    )
  end
end
