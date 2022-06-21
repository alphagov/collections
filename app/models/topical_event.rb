class TopicalEvent
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def title
    @content_item.content_item_data["title"]
  end

  def description
    @content_item.content_item_data["description"]
  end

  def image_url
    @content_item.content_item_data.dig("details", "image", "url")
  end

  def image_alt_text
    @content_item.content_item_data.dig("details", "image", "alt_text")
  end

  def body
    @content_item.content_item_data.dig("details", "body")
  end

  def slug
    @content_item.content_item_data["base_path"].sub(%r{/government/topical-events/}, "")
  end

  def end_date
    Date.parse(@content_item.content_item_data.dig("details", "end_date")) if @content_item.content_item_data.dig("details", "end_date")
  end

  def archived?
    if end_date && end_date <= Time.zone.today
      true
    else
      false
    end
  end

  def about_page_url
    "#{@content_item.content_item_data['base_path']}/about"
  end

  def about_page_link_text
    @content_item.content_item_data.dig("details", "about_page_link_text")
  end

  def social_media_links
    @content_item.content_item_data.dig("details", "social_media_links")&.map do |social_media_link|
      {
        href: social_media_link["href"],
        text: social_media_link["title"],
        icon: social_media_link["service_type"],
      }
    end
  end

  def ordered_featured_documents
    @content_item.content_item_data.dig("details", "ordered_featured_documents")&.map do |document|
      {
        href: document["href"],
        image_src: document.dig("image", "url"),
        image_alt: document.dig("image", "alt_text"),
        heading_text: document["title"],
        description: document["summary"],
      }
    end
  end

  def travel_advice
    return [] if slug != "afghanistan-uk-government-response"

    advice = ContentItem.find!("/foreign-travel-advice/afghanistan").to_hash
    [advice.slice("base_path", "title")]
  end
end
