module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    def initialize(scope = {})
      super('news_and_communications', scope)
    end

    def tagged_content
      @content = MostRecentContent.fetch(scope.merge(filter_content_purpose_supergroup: @name))
    end
  end
end
