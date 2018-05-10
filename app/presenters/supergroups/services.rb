module Supergroups
  class Services < Supergroup
    attr_reader :content

    def initialize
      super('services')
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
            description: document.description,
            data_attributes: data_attributes(document.base_path, index)
          }
        }

        data
      end
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
