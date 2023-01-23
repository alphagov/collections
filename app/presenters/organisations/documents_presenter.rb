module Organisations
  class DocumentsPresenter
    include OrganisationHelper
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def has_featured_news?
      org.ordered_featured_documents.present?
    end

    def first_featured_news
      main_story = featured_news([org.ordered_featured_documents.first], first_featured: true)[0]
      main_story[:large] = true
      main_story
    end

    def remaining_featured_news
      return featured_news(org.ordered_featured_documents.drop(1)) if org.is_news_organisation? && !org.is_no_10?

      return featured_news(org.ordered_featured_documents).map { |news| news.merge({ font_size: "s" }) } if org.is_no_10?

      featured_news(org.ordered_featured_documents)
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

    def has_latest_documents?
      latest_documents[:items].present?
    end

    def latest_documents
      @latest_documents ||= Services.cached_search(
        {
          count: 3,
          order: "-public_timestamp",
          filter_organisations: @org.slug,
          fields: %w[title link content_store_document_type public_timestamp],
        },
        metric_key: "organisations.search.request_time",
      )["results"]

      search_results_to_documents(@latest_documents, @org)
    end

  private

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

    def make_full_width(number_of_items)
      return {} unless number_of_items == 1

      { large: true }
    end

    def featured_news(featured, first_featured: false)
      news_stories = []
      image_size = first_featured ? 712 : 465

      featured.each do |news|
        date = Date.parse(news["public_updated_at"]) if news["public_updated_at"]
        text = I18n.t("shared.schema_name.#{news['document_type']&.parameterize(separator: '_')}", count: 1, default: news["document_type"]) if news["document_type"]

        news_stories << {
          href: news["href"],
          image_src: image_url_by_size(news["image"]["url"], image_size),
          image_alt: news["image"]["alt_text"],
          context: {
            date:,
            text:,
          },
          heading_text: news["title"],
          description: news["summary"].html_safe,
          brand: org.brand,
          heading_level: 3,
        }.merge(org.is_no_10? ? { large: true } : {})
      end

      news_stories
    end

    def promotions_child_column_class(number_of_items)
      return "govuk-grid-column-one-half" if number_of_items == 2

      "govuk-grid-column-one-third" if number_of_items == 3
    end

    def promotional_feature_link(link)
      link.presence
    end
  end
end
