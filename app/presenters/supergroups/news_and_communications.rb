module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    def initialize
      super('news_and_communications')
    end

    def tagged_content(taxon_id)
      @content = MostRecentContent.fetch(content_id: taxon_id, filter_content_store_document_type: document_types)
    end

    def promoted_content(taxon_id)
      items = tagged_content(taxon_id).shift(promoted_content_count)
      format_document_data(items, "FeaturedLinkClicked", true)
    end

  private

    def promoted_content_count(*)
      1
    end
  end
end
