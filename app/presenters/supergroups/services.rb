module Supergroups
  class Services < Supergroup
    attr_reader :content

    def initialize(scope = {})
      super('services', scope)
    end

    def tagged_content
      @content = MostPopularContent.fetch(scope.merge(filter_content_purpose_supergroup: @name))
    end

    def document_list
      tagged_content.each.map do |document|
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
