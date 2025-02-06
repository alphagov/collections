module LatestNewsHelper
  include ActionView::Helpers::TranslationHelper

  def latest_news_items(organisation, get_first_image: false, count: 5)
    search_results = Services.search_api.search({
      filter_content_purpose_supergroup: %w[news_and_communications],
      filter_organisations: [organisation.slug],
      order: "-public_timestamp",
      count:,
    })

    first_image = get_news_item_header_image_from(search_results) if get_first_image

    search_results["results"].each_with_index.map do |result, index|
      {
        href: result["link"],
        image_src: first_image && index.zero? ? first_image["url"] : nil,
        image_alt: first_image && index.zero? ? first_image["alt_text"] : nil,
        heading_text: result["title"],
        text: result["title"],
        metadata: nil,
        brand: organisation.brand,
      }
    end
  end

  def get_news_item_header_image_from(results)
    return nil unless results["results"].any?

    news_item = Services.content_store.content_item(results["results"].first["link"])
    news_item.parsed_content["details"]["image"]
  rescue StandardError => e
    GovukError.notify(e)
    {
      "url" => "https://assets.publishing.service.gov.uk/media/5a37dae940f0b649cceb1841/s300_number10.jpg",
      "alt_text" => "Front door of No. 10 Downing Street",
    }
  end
end
