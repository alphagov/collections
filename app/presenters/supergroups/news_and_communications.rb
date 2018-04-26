module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    def initialize
      super('news_and_communications')
    end

    def tagged_content(taxon_id)
      @content = MostRecentContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: @name)
    end

    def document_list(taxon_id)
      tagged_content(taxon_id).each_with_index.map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path
          },
          metadata: {
            public_updated_at: document.public_updated_at,
            organisations: document.organisations,
            document_type: document.content_store_document_type.humanize
          }
        }

        if index < promoted_content_count
          document_image = news_item_photo(document.base_path)
          data[:image] = {}
          data[:image][:url] = document_image["url"]
          data[:image][:alt] = document_image["alt_text"]
        end

        data
      end
    end

    def news_item_photo(base_path)
      default_news_image = {
        "url": "/government/assets/placeholder.jpg",
        "alt_text": ""
      }.with_indifferent_access

      news_item = ::Services.content_store.content_item(base_path)

      news_item["details"]["image"] || default_news_image
    end

    def promoted_content_count(*)
      1
    end
  end
end
