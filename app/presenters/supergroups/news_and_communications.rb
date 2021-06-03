module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    def initialize
      super("news_and_communications")
    end

    def tagged_content(taxon_id)
      @content = MostRecentContent.fetch(content_id: taxon_id, filter_content_store_document_type: document_types)
    end

    def document_list(taxon_id)
      items = tagged_content(taxon_id).drop(promoted_content_count)

      format_document_data(items)
    end

    def document_list_with_promoted(taxon_id)
      items = tagged_content(taxon_id)

      format_document_data(items)
    end

    def promoted_content(taxon_id)
      items = tagged_content(taxon_id).shift(promoted_content_count)
      format_document_data(items, data_category: "FeaturedLinkClicked", with_image_url: true)
    end

  private

    def promoted_content_count(*)
      1
    end
  end
end
