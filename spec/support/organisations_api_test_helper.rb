module OrganisationsApiTestHelper
  def organisations_params(start: "0")
    {
      filter_format: "organisation",
      order: "title",
      count: "20",
      start:,
    }
  end

  def organisation_params(slug:)
    {
      filter_format: "organisation",
      filter_slug: slug,
      count: "1",
      start: "0",
    }
  end

  def search_api_organisations_results
    {
      results: [asset_recovery_agency, hmrc],
      total: 2,
      start: 0,
    }.deep_stringify_keys
  end

  def search_api_organisations_two_pages_of_results
    {
      results: Array.new(40, hmrc),
      total: 40,
      start: 0,
    }.deep_stringify_keys
  end

  def search_api_organisations_many_results
    {
      results: [],
      total: 1000,
      start: 0,
    }.deep_stringify_keys
  end

  def search_api_organisation_results
    {
      results: [hmrc],
      total: 1,
      start: 0,
    }.deep_stringify_keys
  end

  def search_api_organisation_no_results
    {
      results: [],
      total: 0,
      start: 0,
    }.deep_stringify_keys
  end

  def hmrc
    {
      description: "The home of HM Revenue & Customs on GOV.UK. We are the UK’s tax, payments and customs authority, and we have a vital purpose: we collect the money that pays for the UK’s public services and help families and individuals with targeted financial support. We do this by being impartial and increasingly effective and efficient in our administration. We help the honest majority to get their tax right and make it hard for the dishonest minority to cheat the system.",
      format: "organisation",
      link: "/government/organisations/hm-revenue-customs",
      organisations: [
        {
          organisation_crest: "hmrc",
          acronym: "HMRC",
          link: "/government/organisations/hm-revenue-customs",
          analytics_identifier: "D25",
          public_timestamp: "2015-05-13T11:09:06.000+01:00",
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
    }
  end

  def asset_recovery_agency
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
    }
  end
end
