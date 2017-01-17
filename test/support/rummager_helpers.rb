module RummagerHelpers
  def stub_content_for_taxon(content_id, results)
    Services.rummager.stubs(:search).with(
      filter_taxons: [content_id],
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w(title description link)
    ).returns(
      "results" => results,
      "start" => 0,
      "total" => results.size,
    )
  end

  def stub_topic_organisations(slug, content_id)
    Services.rummager.stubs(:search).with(
      count: "0",
      filter_topic_content_ids: [content_id],
      facet_organisations: "1000",
    ).returns(
      rummager_has_specialist_sector_organisations(slug)
    )
  end

  def stub_services_and_information_links(organisation_id)
    Services.rummager.stubs(:search).with(
      count: "0",
      filter_organisations: organisation_id,
      facet_specialist_sectors: "1000,examples:4,example_scope:query,order:value.title",
    ).returns(
      rummager_has_services_and_info_data_for_organisation
    )
  end

  def stub_services_and_information_links_with_missing_keys(organisation_id)
    Services.rummager.stubs(:search).with(
      count: "0",
      filter_organisations: organisation_id,
      facet_specialist_sectors: "1000,examples:4,example_scope:query,order:value.title",
    ).returns(
      rummager_has_services_and_info_data_with_missing_keys_for_organisation
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
      "document_type" => "edition"
    }
  end

  def rummager_has_latest_documents_for_subtopic(subtopic_content_id, document_slugs, page_size: 50)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Services.rummager.stubs(:search).with(
        has_entries(
          start: start,
          count: page_size,
          filter_topic_content_ids: [subtopic_content_id],
          order: "-public_timestamp",
        )
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
      Services.rummager.stubs(:search).with(
        has_entries(
          start: start,
          count: page_size,
          filter_topic_content_ids: [subtopic_content_id],
        )
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
      Services.rummager.stubs(:search).with(
        has_entries(
          start: start,
          count: page_size,
          filter_mainstream_browse_page_content_ids: [browse_page_content_id],
        )
      ).returns("results" => results_page,
        "start" => start,
        "total" => results.size)
    end
  end

  def expect_search_params(params)
    GdsApi::Rummager.any_instance.expects(:search)
      .with(has_entries(params))
      .returns(:some_results)
  end
end
