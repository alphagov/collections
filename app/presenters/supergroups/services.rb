module Supergroups
  class Services < Supergroup
    attr_reader :content

    def initialize
      super("services")
    end

    def tagged_content(taxon_id)
      @content = MostPopularContent.fetch(content_id: taxon_id, filter_content_store_document_type: document_types)
    end

  private

    def format_document_data(documents, data_category: "")
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            description: document.description,
            data_attributes: data_attributes(document.base_path, document.title, index),
          },
        }

        if data_category.present?
          data[:link][:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end
  end
end
