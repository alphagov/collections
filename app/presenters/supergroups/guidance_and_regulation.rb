module Supergroups
  class GuidanceAndRegulation < Supergroup
    attr_reader :content

    def initialize(scope = {})
      super('guidance_and_regulation', scope)
    end

    def tagged_content
      @content = MostPopularContent.fetch(scope.merge(filter_content_purpose_supergroup: @name))
    end

    def document_list
      tagged_content.each.map do |document|
        data = {
          link: {
            text: document.title,
            path: document.base_path
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
  end
end
