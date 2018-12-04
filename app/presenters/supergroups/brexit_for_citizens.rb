module Supergroups
  class BrexitForCitizens < Supergroup
    include RummagerFields

    attr_reader :content

    def initialize
      super(%w(guidance_and_regulation services))
    end

    def tagged_content(taxon_id)
      @content = search_response_including_brexit(taxon_id, document_types, 3).documents
    end

    def data_module_label
      name.map { |n| n.camelize(:lower) }.join('_')
    end

  private

    def search_response_including_brexit(content_id, filter_content_store_document_type, number_of_links = 5)
      params = {
        start: 0,
        count: number_of_links,
        fields: RummagerFields::TAXON_SEARCH_FIELDS,
        filter_all_part_of_taxonomy_tree: [content_id, 'd6c2de5d-ef90-45d1-82d4-5f2438369eea'],
        order: '-popularity',
        filter_content_store_document_type: filter_content_store_document_type,
      }

      RummagerSearch.new(params)
    end

    def format_document_data(documents, data_category = "")
      documents.each.with_index(1).map do |document, index|
        data = {
          text: document.title,
          path: document.base_path,
          data_attributes: data_attributes(document.base_path, document.title, index)
        }

        if data_category.present?
          data[:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end

    def document_types
      GovukDocumentTypes.supergroup_document_types('guidance_and_regulation', 'services')
    end
  end
end
