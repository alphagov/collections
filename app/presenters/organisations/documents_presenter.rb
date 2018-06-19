module Organisations
  class DocumentsPresenter
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def has_featured_news?
      org.ordered_featured_documents.length.positive?
    end

    def first_featured_news
      main_story = featured_news([org.ordered_featured_documents.first])[0]
      main_story[:large] = true
      main_story
    end

    def remaining_featured_news
      return featured_news(org.ordered_featured_documents.drop(1)) if org.is_news_organisation?
      featured_news(org.ordered_featured_documents)
    end

    def has_latest_documents?
      latest_documents.length.positive?
    end

    def latest_documents
      @latest_documents ||= Services.rummager.search(
        count: 3,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        fields: %w[title link content_store_document_type public_timestamp]
      )["results"]
      search_results_to_documents(@latest_documents)
    end

    def has_latest_announcements?
      latest_announcements.length.positive?
    end

    def latest_announcements
      @latest_announcements ||= search_rummager("announcements")
      search_results_to_documents(@latest_announcements)
    end

    def has_latest_consultations?
      latest_consultations.length.positive?
    end

    def latest_consultations
      @latest_consultations ||= search_rummager("consultations")
      search_results_to_documents(@latest_consultations)
    end

    def has_latest_publications?
      latest_publications.length.positive?
    end

    def latest_publications
      @latest_publications ||= search_rummager("publications")
      search_results_to_documents(@latest_publications)
    end

    def has_latest_statistics?
      latest_statistics.length.positive?
    end

    def latest_statistics
      @latest_statistics ||= search_rummager("statistics")
      search_results_to_documents(@latest_statistics)
    end


  private

    def search_rummager(government_document_supertype)
      Services.rummager.search(
        count: 2,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        filter_government_document_supertype: government_document_supertype,
        fields: %w[title link content_store_document_type public_timestamp]
      )["results"]
    end

    def search_results_to_documents(search_results)
      documents = []

      search_results.each do |item|
        metadata = {}
        metadata[:document_type] = item["content_store_document_type"].capitalize.tr("_", " ")

        if item["public_timestamp"]
          metadata[:public_updated_at] = Date.parse(item["public_timestamp"])
        end

        documents << {
          link: {
            text: item["title"],
            path: item["link"]
          },
          metadata: metadata
        }
      end

      {
        items: documents,
        brand: @org.brand
      }
    end

    def featured_news(featured)
      news_stories = []
      featured.each do |news|
        human_date = Date.parse(news["public_updated_at"]).strftime("%-d %B %Y") if news["public_updated_at"]
        document_type = news["document_type"]
        divider = " — " if human_date && document_type

        news_stories << {
          href: news["href"],
          image_src: news["image"]["url"],
          image_alt: news["image"]["alt_text"],
          context: "#{human_date}#{divider}#{document_type}",
          heading_text: news["title"],
          description: news["summary"],
          brand: org.brand
        }
      end

      news_stories
    end
  end
end
