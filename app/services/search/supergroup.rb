module Search
  class Supergroup
    attr_reader :content_purpose_supergroup, :sort_order

    DEFAULT_SORT_ORDER = '-public_timestamp'.freeze

    def initialize(organisation_slug:, content_purpose_supergroup:, sort_order: DEFAULT_SORT_ORDER)
      @organisation_slug = organisation_slug
      @content_purpose_supergroup = content_purpose_supergroup
      @sort_order = sort_order
    end

    def has_documents?
      documents.any?
    end

    def documents
      @documents ||= search_rummager(
        filter_organisations: @organisation_slug,
        filter_content_purpose_supergroup: @content_purpose_supergroup,
      )
    end

  private

    def search_rummager(additional_params)
      params = default_rummager_params.merge(additional_params).compact

      Services.rummager.search(params)["results"]
    end

    def default_rummager_params
      {
        count: 2,
        order: @sort_order,
        fields: %w[title link content_store_document_type public_timestamp]
      }
    end
  end
end
