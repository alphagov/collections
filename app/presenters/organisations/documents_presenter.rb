module Organisations
  class DocumentsPresenter
    include OrganisationHelper
    include PromotionalFeatureHelper

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

    def has_latest_documents?
      latest_documents[:items].present?
    end

    def latest_documents
      @latest_documents ||= latest_documents_excluding_org_page
      search_results_to_documents(@latest_documents, @org)
    end

  private

    def latest_documents_excluding_org_page
      documents = Services.cached_search(
        {
          count: 4,
          order: "-public_timestamp",
          filter_organisations: @org.slug,
          reject_document_type: "manual_section",
          fields: %w[title link content_store_document_type public_timestamp],
        },
        metric_key: "organisations.search.request_time",
      )["results"]

      documents.reject { |doc| doc["link"] == @org.base_path }.take(3)
    end

    def featured_news(featured, first_featured: false)
      news_stories = []

      featured.each do |news|
        date = Time.zone.parse(news["public_updated_at"]).to_date if news["public_updated_at"]
        text = I18n.t("shared.schema_name.#{news['document_type']&.parameterize(separator: '_')}", count: 1, default: news["document_type"]) if news["document_type"]
        image_src = first_featured ? news["image"]["high_resolution_url"] : news["image"]["medium_resolution_url"]
        image_src ||= news["image"]["url"]

        news_stories << {
          href: news["href"],
          image_src:,
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
  end
end
