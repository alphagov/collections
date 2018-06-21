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

    def has_latest_documents_by_type?
      has_latest_announcements? ||
        has_latest_consultations? ||
        has_latest_publications? ||
        has_latest_statistics?
    end

    def latest_documents_by_type
      all_documents = [
        announcements: latest_announcements,
        consultations: latest_consultations,
        publications: latest_publications,
        statistics: latest_statistics
      ]

      formatted_documents = []

      all_documents.each do |document_group|
        document_group.each do |document_type, documents|
          if documents[:items].length.positive?
            documents[:items].push(
              link: {
                text: I18n.t('organisations.document_types.see_all_documents', type: document_type),
                path: "/government/#{document_type}?departments%5B%5D=#{@org.slug}"
              }
            )

            formatted_documents << {
              documents: documents,
              title: I18n.t('organisations.document_types.' + document_type.to_s),
            }
          end
        end
      end

      formatted_documents.compact
    end

  private

    def search_rummager(filter_email_document_supertype: false, filter_government_document_supertype: false)
      params = {
        count: 2,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        fields: %w[title link content_store_document_type public_timestamp]
      }

      params[:filter_email_document_supertype] = filter_email_document_supertype if filter_email_document_supertype
      params[:filter_government_document_supertype] = filter_government_document_supertype if filter_government_document_supertype

      Services.rummager.search(params)["results"]
    end

    def search_results_to_documents(search_results)
      documents = []

      search_results.each do |item|
        metadata = {}

        if item["public_timestamp"]
          metadata[:public_updated_at] = Date.parse(item["public_timestamp"])
        end

        if item["content_store_document_type"]
          metadata[:document_type] = item["content_store_document_type"].capitalize.tr("_", " ")
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
        brand: (@org.brand unless @org.has_separate_website?)
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

    def has_latest_announcements?
      latest_announcements[:items].length.positive?
    end

    def has_latest_consultations?
      latest_consultations[:items].length.positive?
    end

    def has_latest_publications?
      latest_publications[:items].length.positive?
    end

    def has_latest_statistics?
      latest_statistics[:items].length.positive?
    end

    def latest_announcements
      @latest_announcements ||= search_rummager(filter_email_document_supertype: "announcements")
      search_results_to_documents(@latest_announcements)
    end

    def latest_publications
      @latest_publications ||= search_rummager(filter_email_document_supertype: "publications")
      search_results_to_documents(@latest_publications)
    end

    def latest_consultations
      @latest_consultations ||= search_rummager(filter_government_document_supertype: "consultations")
      search_results_to_documents(@latest_consultations)
    end

    def latest_statistics
      @latest_statistics ||= search_rummager(filter_government_document_supertype: "statistics")
      search_results_to_documents(@latest_statistics)
    end
  end
end
