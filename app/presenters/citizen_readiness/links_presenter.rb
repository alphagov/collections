module CitizenReadiness
  class LinksPresenter
    CITIZEN_TAXON_CONTENT_ID = 'd7bdaee2-8ea5-460e-b00d-6e9382eb6b61'.freeze

    FEATURED_LINKS = %w(
      /visit-europe-brexit
    ).freeze

    FEATURED_TAXONS = %w(
      /work
      /environment
      /business-and-industry
      /education
    ).freeze

    REJECTED_TAXONS = %w(
      /going-and-being-abroad
      /government/all
      /transport
    ).freeze

    def featured_links
      custom_links +
        featured_taxons(custom_links.length)
    end

    def other_links
      @other_links ||= level_one_taxons
        .reject { |content_item| FEATURED_TAXONS.include?(content_item.base_path) }
        .reject { |content_item| REJECTED_TAXONS.include?(content_item.base_path) }
        .select { |content_item| taxon_ids_with_citizen_tagged_content.include?(content_item.content_id) }
        .map { |content_item| TaxonLinkPresenter.new(content_item) }
    end

  private

    def custom_links
      @custom_links ||= FEATURED_LINKS.map.with_index do |base_path, index|
        LinkPresenter.new(base_path, index)
      end
    end

    def featured_taxons(index_offset = 0)
      @featured_taxons ||= FEATURED_TAXONS.map.with_index(index_offset) do |base_path, index|
        featured_taxon = level_one_taxons.detect { |taxon| taxon.base_path == base_path }
        TaxonLinkPresenter.new(featured_taxon, index)
      end
    end

    def level_one_taxons
      @level_one_taxons ||= ContentItem.find!('/').linked_items('level_one_taxons')
    end

    def taxon_ids_with_citizen_tagged_content
      @taxon_ids_with_citizen_tagged_content ||= begin
        params = {
          count: 0,
          facet_part_of_taxonomy_tree: "1000,examples:0,scope:all_filters",
          filter_taxons: CITIZEN_TAXON_CONTENT_ID,
          filter_content_store_document_type: document_types
        }

        search_result = RummagerSearch.new(params)

        search_result.facets["part_of_taxonomy_tree"]["options"].map do |item|
          item.dig("value", "slug")
        end
      end
    end

    def document_types
      %w(travel_advice_index) + GovukDocumentTypes.supergroup_document_types('guidance_and_regulation', 'services')
    end
  end
end
