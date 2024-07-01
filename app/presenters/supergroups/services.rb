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

    def format_document_data(documents)
      documents.each.map do |document|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            description: document.description,
          },
        }

        data
      end
    end
  end
end
