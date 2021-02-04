module SearchApiHelpers
  include SearchApiFields

  def stub_content_for_taxon(content_ids, results)
    params = {
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w[title description link content_store_document_type],
      filter_taxons: Array(content_ids),
      order: "title",
    }

    Services.search_api.stubs(:search)
      .with(params)
      .returns(
        "results" => results,
        "start" => 0,
        "total" => results.size,
      )
  end

  def stub_document_types_for_supergroup(supergroup)
    GovukDocumentTypes.stubs(:supergroup_document_types)
      .with(supergroup)
      .returns(supergroup)
  end

  def stub_most_popular_content_for_taxon(content_id, results,
                                          filter_content_store_document_type: %w[detailed_guide manual])
    fields = SearchApiFields::TAXON_SEARCH_FIELDS

    params = {
      start: 0,
      count: 5,
      fields: fields,
      filter_part_of_taxonomy_tree: Array(content_id),
      order: "-popularity",
      filter_content_store_document_type: filter_content_store_document_type,
    }

    Services.search_api.stubs(:search)
    .with(params)
    .returns(
      "results" => results,
      "start" => 0,
      "total" => results.size,
    )
  end

  def stub_most_recent_content_for_taxon(content_id, results,
                                         filter_content_store_document_type: %w[detailed_guide guidance])
    fields = SearchApiFields::TAXON_SEARCH_FIELDS

    params = {
      start: 0,
      count: 5,
      fields: fields,
      filter_part_of_taxonomy_tree: [content_id],
      order: "-public_timestamp",
      filter_content_store_document_type: filter_content_store_document_type,
    }

    Services.search_api.stubs(:search)
    .with(params)
    .returns(
      "results" => results,
      "start" => 0,
      "total" => results.size,
    )
  end

  def stub_organisations_for_taxon(content_id, organisations)
    params = {
      count: 0,
      aggregate_organisations: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      filter_part_of_taxonomy_tree: [content_id],
    }

    Services.search_api
    .stubs(:search)
    .with(params)
    .returns(
      "results" => [],
      "aggregates" => {
        "organisations" => {
          "options" => organisations,
        },
      },
    )
  end

  def generate_search_results(count, supergroup = "default")
    (1..count).map do |number|
      case supergroup
      when "services"
        rummager_document_for_supergroup_section("content-item-#{number}", "local_transaction")
      when "guidance_and_regulation"
        if number <= 2
          rummager_document_for_supergroup_section("content-item-#{number}", "guide")
        else
          rummager_document_for_supergroup_section("content-item-#{number}", "guidance")
        end
      when "news_and_communications"
        rummager_document_for_supergroup_section("content-item-#{number}", "news_story")
      when "policy_and_engagement"
        rummager_document_for_supergroup_section("content-item-#{number}", "policy_paper")
      when "transparency"
        rummager_document_for_supergroup_section("content-item-#{number}", "transparency")
      when "research_and_statistics"
        rummager_document_for_supergroup_section("content-item-#{number}", "research")
      else
        rummager_document_for_slug("content-item-#{number}")
      end
    end
  end

  def stub_topic_organisations(slug, content_id)
    Services.search_api.stubs(:search).with(
      count: "0",
      filter_topic_content_ids: [content_id],
      facet_organisations: "1000",
    ).returns(
      stub_search_has_specialist_sector_organisations(slug),
    )
  end

  def stub_services_and_information_links(organisation_id)
    Services.search_api.stubs(:search).with(
      count: "0",
      filter_organisations: organisation_id,
      facet_specialist_sectors: "1000,examples:4,example_scope:query,order:value.title",
    ).returns(
      stub_search_has_services_and_info_data_for_organisation,
    )
  end

  def stub_services_and_information_links_with_missing_keys(organisation_id)
    Services.search_api.stubs(:search).with(
      count: "0",
      filter_organisations: organisation_id,
      facet_specialist_sectors: "1000,examples:4,example_scope:query,order:value.title",
    ).returns(
      stub_search_has_services_and_info_data_with_missing_keys_for_organisation,
    )
  end

  def rummager_document_for_slug(slug, updated_at = 1.hour.ago, format = "guide")
    {
      "format" => format.to_s,
      "latest_change_note" => "This has changed",
      "public_timestamp" => updated_at.iso8601,
      "title" => slug.titleize.humanize.to_s,
      "link" => "/#{slug}",
      "index" => "/",
      "_id" => "/#{slug}",
      "document_type" => "edition",
      "content_store_document_type" => "guidance",
      "organisations" => [{ "title" => "Tagged Organisation Title" }],
    }
  end

  def rummager_document_for_supergroup_section(slug, content_store_document_type)
    {
      "title" => slug.titleize.humanize.to_s,
      "link" => "/#{slug}",
      "description" => "A discription about tagged content",
      "content_store_document_type" => content_store_document_type,
      "public_timestamp" => 1.hour.ago.iso8601,
      "organisations" => [{ "title" => "#{content_store_document_type.humanize} Organisation Title" }],
    }
  end

  def rummager_has_latest_documents_for_subtopic(subtopic_content_id, document_slugs, page_size: 50)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Services.search_api.stubs(:search).with(
        has_entries(
          start: start,
          count: page_size,
          filter_topic_content_ids: [subtopic_content_id],
          order: "-public_timestamp",
        ),
      ).returns("results" => results_page,
                "start" => start,
                "total" => results.size)
    end
  end

  def rummager_has_documents_for_subtopic(subtopic_content_id, document_slugs, format = "guide", page_size: 50)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago, format)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Services.search_api.stubs(:search).with(
        has_entries(
          start: start,
          count: page_size,
          filter_topic_content_ids: [subtopic_content_id],
        ),
      ).returns("results" => results_page,
                "start" => start,
                "total" => results.size)
    end
  end

  def rummager_has_documents_for_browse_page(browse_page_content_id, document_slugs, format = "guide", page_size: 50)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago, format)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Services.search_api.stubs(:search).with(
        has_entries(
          start: start,
          count: page_size,
          filter_mainstream_browse_page_content_ids: [browse_page_content_id],
        ),
      ).returns("results" => results_page,
                "start" => start,
                "total" => results.size)
    end
  end

  def rummager_has_documents_for_second_level_browse_page(browse_page_content_id, document_slugs, format = "guide", page_size: 1000)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago, format)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Services.search_api.stubs(:search).with(
        start: start,
        count: page_size,
        filter_mainstream_browse_page_content_ids: [browse_page_content_id],
        fields: %w[title link format],
      ).returns("results" => results_page,
                "start" => start,
                "total" => results.size)
    end
  end

  def expect_search_params(params)
    GdsApi::Search.any_instance.expects(:search)
      .with(has_entries(params))
      .returns(:some_results)
  end

  def section_tagged_content_list(doc_type, count = 1)
    content_list = []

    params = {
      title: "Tagged Content Title",
      description: "Description of tagged content",
      public_updated_at: "2018-02-28T08:01:00.000+00:00",
      base_path: "/government/tagged/content",
      content_store_document_type: doc_type,
      organisations: "Tagged Content Organisation",
      image_url: "an/image/path",
    }

    if doc_type.include?("consultation")
      params[:end_date] = "2018-08-28T08:01:00.000+01:00"
    end

    count.times do
      content_list.push(
        Document.new(params),
      )
    end

    content_list
  end

  def stub_supergroup_request(results: [], additional_params: {})
    params = {
      count: 2,
      fields: %w[title link content_store_document_type public_timestamp],
      order: "-public_timestamp",
    }.merge(additional_params)

    Services.search_api.stubs(:search)
      .with(params)
      .returns(
        "results" => results,
        "start" => 0,
        "total" => results.size,
      )
  end
end
