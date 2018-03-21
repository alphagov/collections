module RummagerHelpers
  def stub_content_for_taxon(content_ids, results, filter_navigation_document_supertype: 'guidance')
    params = {
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w(title description link document_collections content_store_document_type),
      filter_taxons: Array(content_ids),
      order: 'title',
    }
    params[:filter_navigation_document_supertype] = filter_navigation_document_supertype if filter_navigation_document_supertype.present?

    Services.rummager.stubs(:search)
      .with(params)
      .returns(
        "results" => results,
        "start" => 0,
        "total" => results.size,
      )
  end

  def stub_most_popular_content_for_taxon(content_id, results, filter_content_purpose_supergroup: 'guidance_and_regulation')
    fields = %w(title
                link
                description
                content_store_document_type
                public_timestamp
                organisations)

    params = {
      start: 0,
      count: 5,
      fields: fields,
      filter_taxons: Array(content_id),
      order: '-popularity',
    }
    params[:filter_content_purpose_supergroup] = filter_content_purpose_supergroup if filter_content_purpose_supergroup.present?

    Services.rummager.stubs(:search)
    .with(params)
    .returns(
      "results" => results,
      "start" => 0,
      "total" => results.size,
    )
  end

  def stub_most_recent_content_for_taxon(content_id, results, filter_content_purpose_supergroup: 'news_and_communication')
    fields = %w(title
                link
                content_store_document_type
                public_timestamp
                organisations)

    params = {
      start: 0,
      count: 5,
      fields: fields,
      filter_taxons: [content_id],
      order: '-public_timestamp',
    }
    params[:filter_content_purpose_supergroup] = filter_content_purpose_supergroup if filter_content_purpose_supergroup.present?

    Services.rummager.stubs(:search)
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
      filter_taxons: [content_id]
    }

    Services.rummager
    .stubs(:search)
    .with(params)
    .returns(
      'results' => [],
      'aggregates' => {
        'organisations' => {
          'options' => organisations
        }
      }
    )
  end

  def generate_search_results(count)
    (1..count).map do |number|
      rummager_document_for_slug("content-item-#{number}")
    end
  end

  def generate_search_results_for_services(count)
    (1..count).map do |number|
      rummager_document_for_services("content-item-#{number}")
    end
  end

  def generate_search_results_for_guides(count)
    (1..count).map do |number|
      rummager_document_for_guides("content-item-#{number}")
    end
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
      "document_type" => "edition",
      "content_store_document_type" => "guidance"
    }
  end

  def rummager_document_for_services(slug, updated_at = 1.hour.ago)
    {
      "format" => "local_transaction",
      "latest_change_note" => "This has changed",
      "public_timestamp" => updated_at.iso8601,
      "title" => slug.titleize.humanize.to_s,
      "link" => "/#{slug}",
      "index" => "/",
      "_id" => "/#{slug}",
      "document_type" => "edition",
      "content_store_document_type" => "local_transaction",
      "description" => "A description about #{slug.titleize.humanize.to_s}"
    }
  end

  def rummager_document_for_guides(slug, updated_at = 1.hour.ago)
    {
      "format" => "guide",
      "latest_change_note" => "This has changed",
      "public_timestamp" => updated_at.iso8601,
      "title" => slug.titleize.humanize.to_s,
      "link" => "/#{slug}",
      "index" => "/",
      "_id" => "/#{slug}",
      "document_type" => "edition",
      "content_store_document_type" => "guide",
      "description" => "A description about #{slug.titleize.humanize.to_s}"
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

  def rummager_has_documents_for_second_level_browse_page(browse_page_content_id, document_slugs, format = "guide", page_size: 1000)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago, format)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Services.rummager.stubs(:search).with(
        start: start,
        count: page_size,
        filter_mainstream_browse_page_content_ids: [browse_page_content_id],
        fields: %w(title link format),
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
