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
      tagged_content(taxon_id).each.map do |document|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            description: document.description
          }
        }

        data
      end
    end
  end
end
