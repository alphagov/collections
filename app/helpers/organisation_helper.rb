module OrganisationHelper
  def child_organisation_count(organisation)
    child_orgs = organisation.content_item.content_item_data["links"]["ordered_child_organisations"]
    child_orgs.present? ? child_orgs.count : 0
  end

  def organisation_type_name(organisation_type)
    I18n.t("organisations.type.#{organisation_type}", default: I18n.t("organisations.type.other"))
  end

  def translated_search_result(result)
    return result if I18n.locale == :en

    content_item = get_content_item(result["link"])

    return get_translation_for_mainstream_pages(content_item) if content_item["publishing_app"] == "publisher"

    return result if content_item.dig("links", "available_translations").nil?

    content_item["links"]["available_translations"].each do |t|
      if t["locale"] == I18n.locale.to_s
        return {
          "title" => t["title"],
          "link" => t["base_path"],
          "content_store_document_type" => t["document_type"],
          "public_timestamp" => t["public_updated_at"],
        }
      end
    end

    result
  end

  def get_translation_for_mainstream_pages(content_item)
    content_details = content_item["details"] || {}

    introductory_paragraph =
      content_details["introductory_paragraph"] ||
      content_details.dig("parts", 0, "body") ||
      content_details["body"]

    return { "title" => content_item["title"], "link" => content_item["base_path"] } if introductory_paragraph.nil?

    welsh_translation_link_regex = /This (.*) also available (in )?<a href="(.*)">(in )?Welsh/

    if welsh_translation_link_regex.match?(introductory_paragraph)
      base_path = welsh_translation_link_regex.match(introductory_paragraph)[3]
      translated_item = get_content_item(base_path)

      { "title" => translated_item["title"], "link" => translated_item["base_path"] }
    else
      { "title" => content_item["title"], "link" => content_item["base_path"] }
    end
  end

  def get_untranslated_organisation_base_path(base_path)
    organisation_base_path = base_path

    content_item = get_content_item(base_path)
    if content_item.dig("links", "available_translations")
      content_item["links"]["available_translations"].each do |t|
        if t["locale"] == "en"
          organisation_base_path = t["base_path"]
        end
      end
    end

    organisation_base_path
  end

  def search_results_to_documents(search_results, organisation, include_metadata: true)
    {
      brand: (organisation.brand if organisation.is_live?),
      items: search_results.map do |result|
        Organisations::DocumentPresenter.new(translated_search_result(result), include_metadata:).present
      end,
    }
  end

private

  def handle_api_errors
    yield
  rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl
    {}
  end

  def get_content_item(base_path)
    handle_api_errors do
      Services.content_store.content_item(base_path).parsed_content
    end
  end
end
