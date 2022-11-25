module OrganisationFeedHelpers
  include SearchApiHelpers

  def stub_content_for_organisation_feed(organisation, results)
    params = {
      start: "0",
      count: "20",
      fields: webmock_match_array(%w[title link description display_type public_timestamp]),
      filter_organisations: organisation,
      reject_content_purpose_supergroup: "other",
      order: "-public_timestamp",
    }
    body = {
      "results" => results,
      "start" => 0,
      "total" => results.size,
    }
    stub_search(params:, body:)
  end

  def stub_empty_results
    body = {
      "results" => [],
      "start" => 0,
      "total" => 0,
    }
    stub_search(body:)
  end

  def stub_content_for_government_feed
    params = {
      start: "0",
      count: "20",
      fields: webmock_match_array(%w[title link description display_type public_timestamp]),
      reject_content_purpose_supergroup: "other",
      order: "-public_timestamp",
    }
    body = {
      "results" => results_from_search_api,
      "start" => 0,
      "total" => results_from_search_api.size,
    }
    stub_search(params:, body:)
  end

  def results_from_search_api
    [
      {
        "content_store_document_type" => "document_collection",
        "description" => "This series brings together all documents relating to OWL and NEWT syllabuses, examinations and grading",
        "display_type" => "Detailed guide",
        "link" => "/government/collections/owl-and-newt-examinations-at-hogwarts",
        "organisations" => [
          {
            "organisation_brand" => @organisation_slug,
            "logo_formatted_title" => "Ministry of Magic",
            "organisation_crest" => "single-identity",
            "title" => "Ministry of Magic",
            "content_id" => "96ae61d6-c2a1-48cb-8e67-da9d105ae381",
            "link" => @base_path,
            "slug" => @organisation_slug,
            "organisation_type" => "ministerial_department",
            "organisation_state" => "live",
          },
        ],
        "public_timestamp" => @updated_at,
        "title" => "OWL and NEWT qualifications, Ministry of Magic",
        "index" => "government",
        "es_score" => nil,
        "_id" => "/government/collections/owl-and-newt-examinations-at-hogwarts",
        "elasticsearch_type" => "edition",
        "document_type" => "edition",
      },
      {
        "content_store_document_type" => "detailed_guide",
        "description" => "Defence against the dark arts: Angry acolytes to deepening dread",
        "display_type" => "Detailed guide",
        "link" => "/government/guidance/dark-arts-acolytes-to-dread",
        "organisations" => [
          {
            "organisation_brand" => @organisation_slug,
            "logo_formatted_title" => "Ministry of Magic",
            "organisation_crest" => "single-identity",
            "title" => "Ministry of Magic",
            "content_id" => "96ae61d6-c2a1-48cb-8e67-da9d105ae381",
            "link" => @base_path,
            "slug" => @organisation_slug,
            "organisation_type" => "ministerial_department",
            "organisation_state" => "live",
          },
        ],
        "public_timestamp" => "2018-12-26T12:23:34+01:00",
        "title" => "Dealing with you know who, Ministry of Magic",
        "index" => "government",
        "es_score" => nil,
        "_id" => "/government/guidance/dark-arts-acolytes-to-dread",
        "elasticsearch_type" => "edition",
        "document_type" => "edition",
      },
    ]
  end
end
