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
      return featured_news(org.ordered_featured_documents.drop(1)) if org.is_news_organisation?

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
          number_of_items: number_of_items,
          parent_column_class: "column-#{number_of_items}",
          child_column_class: promotions_child_column_class(number_of_items),
          items: items_for_a_promotional_feature(feature)
        }
      end
    end

    def has_latest_documents?
      latest_documents[:items].present?
    end

    def latest_documents
      @latest_documents ||= Services.rummager.search(
        count: 3,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        reject_content_purpose_supergroup: "other",
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
          if documents[:items].present?
            documents[:items].push(
              link: {
                text: I18n.t(
                  :text,
                  organisation: @org.slug,
                  scope: [:organisations, :document_types, document_type, :see_all],
                ),
                path: I18n.t(
                  :path,
                  organisation: @org.slug,
                  scope: [:organisations, :document_types, document_type, :see_all],
                ),
              }
            )

            formatted_documents << {
              documents: documents,
              title: I18n.t(:title, scope: [:organisations, :document_types, document_type]),
            }
          end
        end
      end

      formatted_documents.compact
    end

  private

    def items_for_a_promotional_feature(feature)
      feature["items"].map do |item|
        data = {
          description: item["summary"].gsub("\r\n", "<br/>").html_safe,
          href: promotional_feature_link(item["href"]),
          image_src: item["image"]["url"],
          image_alt: item["image"]["alt_text"],
          extra_links: item["links"].map do |link|
            {
              text: link["title"],
              href: link["href"]
            }
          end,
          brand: org.brand,
          heading_level: 3
        }

        if item["title"].present?
          data[:heading_text] = item["title"]
        end

        data
      end
    end

    def search_rummager(filter_content_purpose_supergroup: false, filter_government_document_supertype: false, reject_government_document_supertype: false)
      params = {
        count: 2,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        fields: %w[title link content_store_document_type public_timestamp]
      }

      params[:filter_content_purpose_supergroup] = filter_content_purpose_supergroup if filter_content_purpose_supergroup
      params[:filter_government_document_supertype] = filter_government_document_supertype if filter_government_document_supertype
      params[:reject_government_document_supertype] = reject_government_document_supertype if reject_government_document_supertype

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

          # Handle document types with acronyms
          document_acronyms = %w{Foi Dfid Aaib Cma Esi Hmrc Html Maib Raib Utaac}
          document_acronyms.each do |acronym|
            metadata[:document_type].gsub!(acronym, acronym.upcase)
          end
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
        brand: (@org.brand if @org.is_live?)
      }
    end

    def featured_news(featured, first_featured: false)
      news_stories = []
      image_size = first_featured ? 712 : 465

      featured.each do |news|
        date = Date.parse(news["public_updated_at"]) if news["public_updated_at"]

        news_stories << {
          href: news["href"],
          image_src: image_url_by_size(news["image"]["url"], image_size),
          image_alt: news["image"]["alt_text"],
          context: {
            date: date,
            text: news["document_type"]
          },
          heading_text: news["title"],
          description: news["summary"].html_safe,
          brand: org.brand,
          heading_level: 3
        }
      end

      news_stories
    end

    def has_latest_announcements?
      latest_announcements[:items].present?
    end

    def has_latest_consultations?
      latest_consultations[:items].present?
    end

    def has_latest_publications?
      latest_publications[:items].present?
    end

    def has_latest_statistics?
      latest_statistics[:items].present?
    end

    def latest_announcements
      @latest_announcements ||= search_rummager(filter_content_purpose_supergroup: "news_and_communications")
      search_results_to_documents(@latest_announcements)
    end

    def latest_publications
      @latest_publications ||= search_rummager(
        filter_content_purpose_supergroup: %w(guidance_and_regulation policy_and_engagement transparency),
        reject_government_document_supertype: %w(consultations statistics)
      )
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

    def promotions_child_column_class(number_of_items)
      return "column-half" if number_of_items == 2

      "column-one-third" if number_of_items == 3
    end

    def promotional_feature_link(link)
      link if link.present?
    end
  end
end
