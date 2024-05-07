module PromotionalFeatureHelper
  include ActionView::Helpers::TranslationHelper

  def is_video_promotional_feature?(feature)
    return false unless feature[:items]&.any?

    feature[:items].first[:youtube_video_id].present?
  end

  def promotional_video_feature_item_links
    promotional_video_feature[:items].first[:extra_details].map do |link|
      { href: link[:href], text: link[:text] }
    end
  end

  def promotional_video_feature_youtube_url
    "https://www.youtube.com/watch?v=#{promotional_video_feature[:items].first[:youtube_video_id]}"
  end

  def promotional_video_feature_title
    promotional_video_feature[:items].first[:youtube_video_alt]
  end

  def promotional_video_feature
    promotional_features.select { |feature| is_video_promotional_feature?(feature) }.first
  end

  def promotional_image_features
    promotional_features.reject { |feature| is_video_promotional_feature?(feature) }
  end

  def has_promotional_video_feature?
    promotional_features.select { |feature| is_video_promotional_feature?(feature) }.any?
  end

  def has_promotional_features?
    org.ordered_promotional_features.present?
  end

  def promotional_features
    org.ordered_promotional_features.map do |feature|
      number_of_items = feature["items"].length
      {
        title: feature["title"],
        number_of_items:,
        child_column_class: promotions_child_column_class(number_of_items),
        items: items_for_a_promotional_feature(feature),
      }
    end
  end

  def promotions_child_column_class(number_of_items)
    return "govuk-grid-column-one-half" if number_of_items == 2

    "govuk-grid-column-one-third" if number_of_items == 3
  end

  def items_for_a_promotional_feature(feature)
    number_of_items = feature["items"].length
    feature["items"].map do |item|
      data = {
        description: item["summary"].gsub("\r\n", "<br/>").html_safe,
        href: promotional_feature_link(item["href"]),
        image_src: item.dig("image", "url"),
        image_alt: item.dig("image", "alt_text"),
        youtube_video_id: item.dig("youtube_video", "id"),
        youtube_video_alt: item.dig("youtube_video", "alt_text"),
        extra_details: item["links"].map do |link|
          {
            text: link["title"],
            href: link["href"],
          }
        end,
        brand: org.brand,
        heading_level: 3,
        extra_details_no_indent: true,
      }.merge(make_full_width(number_of_items))

      if item["title"].present?
        data[:heading_text] = item["title"]
      end

      data
    end
  end

  def promotional_feature_link(link)
    link.presence
  end

  def make_full_width(number_of_items)
    return {} unless number_of_items == 1

    { large: true }
  end
end
