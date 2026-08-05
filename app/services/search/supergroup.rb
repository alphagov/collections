module Search
  class Supergroup
    attr_reader :content_purpose_supergroup

    DEFAULT_SORT_ORDER = "-public_timestamp".freeze

    def initialize(organisation_slug:, content_purpose_supergroup:)
      @organisation_slug = organisation_slug
      @content_purpose_supergroup = content_purpose_supergroup
    end

    def has_documents?
      documents.any?
    end

    def documents
      @documents ||= search_search_api(documents_query)
    end

    def documents_query
      {
        filter_organisations: @organisation_slug,
        filter_content_purpose_supergroup: @content_purpose_supergroup,
      }.merge(additional_search_params)
    end

  private

    def additional_search_params
      {
        "guidance_and_regulation" => {
          order: "-popularity",
        },
        "news_and_communications" => {
          reject_content_purpose_subgroup: %w[decisions updates_and_alerts],
        },
        "services" => {
          order: "-popularity",
        },
      }.fetch(content_purpose_supergroup, {})
    end

    def search_search_api(additional_params)
      params = default_search_api_params.merge(additional_params).compact

      Services.search_api.search(params)["results"]
    end

    def default_search_api_params
      {
        count: 2,
        order: DEFAULT_SORT_ORDER,
        fields: %w[title link content_store_document_type public_timestamp],
      }
    end
  end
end
