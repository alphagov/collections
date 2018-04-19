module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    def initialize
      super('news_and_communications')
    end

    def tagged_content(taxon_id)
      @content = MostRecentContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: @name)
    end


    def promoted_content_count(*)
      1
    end
  end
end
