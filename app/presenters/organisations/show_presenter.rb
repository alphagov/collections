module Organisations
  class ShowPresenter
    attr_reader :org, :latest

    def initialize(organisation)
      @org = organisation
    end

    def prefixed_title
      prefix = needs_definite_article?(org.title) ? "the " : ""
      (prefix + org.title)
    end

    def has_latest_documents?
      @latest = latest_documents
      @latest.length.positive?
    end

    def latest_documents
      documents = []

      Services.rummager.search(count: 3, order: "-public_timestamp", filter_organisations: org.slug, fields: %w[title link content_store_document_type public_timestamp])["results"].each do |item|
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
        brand: org.brand
      }
    end

    def subscription_links
      {
        email_signup_link: "/government/email-signup/new?email_signup[feed]=#{org.web_url}.atom",
        feed_link_box_value: "#{org.web_url}.atom",
        brand: org.brand
      }
    end

    def has_featured_policies?
      true if org.ordered_featured_policies && org.ordered_featured_policies.length.positive?
    end

    def featured_policies
      policies = []

      org.ordered_featured_policies.each do |policy|
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
          path: "/government/policies?organisations[]=#{org.slug}"
        }
      }

      {
        items: policies,
        brand: org.brand
      }
    end

  private

    def needs_definite_article?(phrase)
      exceptions = [/civil service resourcing/, /^hm/, /ordnance survey/]
      !has_definite_article?(phrase) && !(exceptions.any? { |e| e =~ phrase.downcase })
    end

    def has_definite_article?(phrase)
      phrase.downcase.strip[0..2] == 'the'
    end
  end
end
