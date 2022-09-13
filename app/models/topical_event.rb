class TopicalEvent
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
    @documents_service = SearchDocuments.new(slug, "filter_topical_events")
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

  def most_popular_from_last_7_days
    formatted_last_7_days = (Time.zone.now - 7.days).strftime("%Y-%m-%d")
    { order: "-popularity", filter_public_timestamp: "from:#{formatted_last_7_days}" }
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
        description: document["summary"].truncate(160, separator: " "),
      }
    end
  end

  def travel_advice
    return [] if slug != "afghanistan-uk-government-response"

    advice = ContentItem.find!("/foreign-travel-advice/afghanistan").to_hash
    [advice.slice("base_path", "title")]
  end

  def latest
    @latest ||= @documents_service.fetch_related_documents_with_format
  end

  def publications
    @publications ||= @documents_service.fetch_related_documents_with_format({ filter_format: "publication" })
  end

  def consultations
    @consultations ||= @documents_service.fetch_related_documents_with_format({ filter_format: "consultation" })
  end

  def announcements
    @announcements ||= @documents_service.fetch_related_documents_with_format({ filter_content_purpose_supergroup: "news_and_communications", reject_content_purpose_subgroup: %w[decisions updates_and_alerts] }.merge(most_popular_from_last_7_days))
  end

  def guidance_and_regulation
    @guidance_and_regulation ||= @documents_service.fetch_related_documents_with_format({ filter_content_purpose_supergroup: "guidance_and_regulation" }.merge(most_popular_from_last_7_days))
  end

  def organisations
    @content_item.content_item_data.dig("links", "organisations")&.map do |organisation|
      {
        content_id: organisation["content_id"],
        base_path: organisation["base_path"],
        title: organisation["title"],
        crest: organisation.dig("details", "logo", "crest"),
        brand: organisation.dig("details", "brand"),
      }
    end
  end

  def emphasised_organisations
    @content_item.content_item_data.dig("details", "emphasised_organisations")&.map do |organisation_content_id|
      @content_item.content_item_data.dig("links", "organisations")&.select { |organisation| organisation["content_id"] == organisation_content_id }
    end
  end
end
