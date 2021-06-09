module Supergroups
  class GuidanceAndRegulation < Supergroup
    attr_reader :content

    def initialize
      super("guidance_and_regulation")
    end

    def tagged_content(taxon_id)
      @content = MostPopularContent.fetch(content_id: taxon_id, filter_content_store_document_type: document_types)
    end

  private

    def guide?(document)
      # Although answers and guides are 2 different document types, they are conceptually the same so
      # we should treat them the same
      document.content_store_document_type == "guide" || document.content_store_document_type == "answer"
    end

    def format_document_data(documents, data_category: "")
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            data_attributes: data_attributes(document.base_path, document.title, index),
          },
          metadata: {
            document_type: document.content_store_document_type.humanize,
          },
        }

        if guide?(document)
          data[:link][:description] = document.description
        else
          data[:metadata][:public_updated_at] = document.public_updated_at
          data[:metadata][:organisations] = document.organisations
        end

        if data_category.present?
          data[:link][:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end
  end
end
