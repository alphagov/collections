module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    def initialize
      super('news_and_communications')
    end

    def promoted_content(taxon_id)
      items = tagged_content(taxon_id).shift(promoted_content_count)

      documents = format_document_data(items, "FeaturedLinkClicked")

      documents.map do |document|
        document_image = news_item_photo(document[:link][:path])
        document[:image] = {
          url: document_image["url"],
          alt: document_image["alt_text"]
        }
      end

      documents
    end

    def news_item_photo(base_path)
      default_news_image = {
        "url": "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg",
        "alt_text": ""
      }.with_indifferent_access

      news_item = ::Services.content_store.content_item(base_path)

      news_item["details"]["image"] || default_news_image
    end

  private

    def promoted_content_count(*)
      1
    end
  end
end
