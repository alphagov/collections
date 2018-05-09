module Supergroups
  class GuidanceAndRegulation < Supergroup
    attr_reader :content

    def initialize
      super('guidance_and_regulation')
    end

    def tagged_content(taxon_id)
      @content = MostPopularContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: @name)
    end

    def document_list(taxon_id)
      tagged_content(taxon_id).each_with_index.map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            data_attributes: data_attributes(document.base_path, index)
          },
          metadata: {
            document_type: document.content_store_document_type.humanize
          }
        }

        if guide?(document)
          data[:link][:description] = document.description
        else
          data[:metadata][:public_updated_at] = document.public_updated_at
          data[:metadata][:organisations] = document.organisations
        end

        data
      end
    end

    def guide?(document)
      # Although answers and guides are 2 different document types, they are conceptually the same so
      # we should treat them the same
      document.content_store_document_type == 'guide' || document.content_store_document_type == 'answer'
    end

  private

    def data_attributes(base_path, index)
      {
        track_category: data_module_label + "DocumentListClicked",
        track_action: index + 1,
        track_label: base_path
      }
    end
  end
end
