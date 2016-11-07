module ServicesAndInformationHelpers
  def stub_services_and_information_content_item
    content_store_has_item("/government/organisations/hm-revenue-customs/services-information",
      base_path: "/government/organisations/hm-revenue-customs/services-information",
      title: "Services and information - HM Revenue & Customs",
      description: "",
      document_type: "services_and_information",
      public_updated_at: 10.days.ago.iso8601,
      details: {},
      links: {
        parent: [
          {
            analytics_identifier: "D25",
            base_path: "/government/organisations/hm-revenue-customs",
            title: "HM Revenue & Customs",
          },
        ],
      },
    )
  end
end
