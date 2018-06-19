module Organisations
  class ShowPresenter
    def initialize(organisation)
      @org = organisation
    end

    def prefixed_title
      prefix = needs_definite_article?(@org.title) ? "the " : ""
      (prefix + @org.title)
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
        statistics: latest_statistics]

      formatted_documents = []

      all_documents.each do |document_group|
        document_group.each do |document_type, documents|
          if documents[:items].length > 1
            formatted_documents << {
              documents: documents,
              title: I18n.t('organisations.document_types.' + document_type.to_s),
            }
          end
        end
      end

      formatted_documents.compact
    end

    def subscription_links
      {
        email_signup_link: "/government/email-signup/new?email_signup[feed]=#{@org.web_url}.atom",
        feed_link_box_value: "#{@org.web_url}.atom",
        brand: @org.brand
      }
    end

    def has_featured_policies?
      true if @org.ordered_featured_policies && @org.ordered_featured_policies.length.positive?
    end

    def featured_policies
      policies = []

      @org.ordered_featured_policies.each do |policy|
        policies << {
          link: {
            text: policy["title"],
            path: policy["base_path"]
          }
        }
      end

      policies << {
        link: {
          text: "See all our policies",
          path: "/government/policies?organisations[]=#{@org.slug}"
        }
      }

      {
        items: policies,
        brand: @org.brand
      }
    end

  private

    def search_results_to_documents(search_results, see_all_link: false)
      documents = []

      search_results.each do |item|
        metadata = {}

        if item["public_timestamp"]
          metadata[:public_updated_at] = Date.parse(item["public_timestamp"])
        end

        metadata[:document_type] = item["content_store_document_type"].capitalize.tr("_", " ")

        documents << {
          link: {
            text: item["title"],
            path: item["link"]
          },
          metadata: metadata
        }
      end

      if see_all_link
        documents << {
          link: {
            text: I18n.t('organisations.document_types.see_all_documents', type: see_all_link),
            path: "/government/#{see_all_link}?departments%5B%5D=#{@org.slug}"
          }
        }
      end

      {
        items: documents,
        brand: @org.brand
      }
    end

    def needs_definite_article?(phrase)
      exceptions = [/civil service resourcing/, /^hm/, /ordnance survey/]
      !has_definite_article?(phrase) && !(exceptions.any? { |e| e =~ phrase.downcase })
    end

    def has_definite_article?(phrase)
      phrase.downcase.strip[0..2] == 'the'
    end


    def has_latest_announcements?
      latest_announcements.length.positive?
    end

    def latest_announcements
      @latest_announcements ||= Services.rummager.search(
        count: 2,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        filter_email_document_supertype: "announcements",
        fields: %w[title link content_store_document_type public_timestamp]
      )["results"]
      search_results_to_documents(@latest_announcements, see_all_link: "announcements")
    end

    def has_latest_consultations?
      latest_consultations.length.positive?
    end

    def latest_consultations
      @latest_consultations ||= Services.rummager.search(
        count: 2,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        filter_government_document_supertype: "consultations",
        fields: %w[title link content_store_document_type public_timestamp]
      )["results"]
      search_results_to_documents(@latest_consultations, see_all_link: "consultations")
    end

    def has_latest_publications?
      latest_publications.length.positive?
    end

    def latest_publications
      @latest_publications ||= Services.rummager.search(
        count: 2,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        filter_email_document_supertype: "publications",
        fields: %w[title link content_store_document_type public_timestamp]
      )["results"]
      search_results_to_documents(@latest_publications, see_all_link: "publications")
    end

    def has_latest_statistics?
      latest_statistics.length.positive?
    end

    def latest_statistics
      @latest_statistics ||= Services.rummager.search(
        count: 2,
        order: "-public_timestamp",
        filter_organisations: @org.slug,
        filter_government_document_supertype: "statistics",
        fields: %w[title link content_store_document_type public_timestamp]
      )["results"]
      search_results_to_documents(@latest_statistics, see_all_link: "statistics")
    end
  end
end
