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
      items = tagged_content(taxon_id).drop(promoted_content_count)

      format_document_data(items)
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

    def format_document_data(documents, data_category = "")
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            data_attributes: data_attributes(document.base_path, index)
          },
          metadata: {
            public_updated_at: document.public_updated_at,
            organisations: document.organisations,
            document_type: document.content_store_document_type.humanize
          }
        }

        if data_category.present?
          data[:link][:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end
  end
end
