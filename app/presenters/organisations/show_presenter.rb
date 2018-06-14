module Organisations
  class ShowPresenter
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def prefixed_title
      prefix = needs_definite_article?(org.title) ? "the " : ""
      (prefix + org.title)
    end

    def has_latest_documents?
      org.ordered_featured_documents.length.positive?
    end

    def latest_documents
      documents = []

      org.ordered_featured_documents.each do |story|
        metadata = {}
        metadata[:document_type] = story["document_type"]

        if story["public_updated_at"]
          metadata[:public_updated_at] = Date.parse(story["public_updated_at"])
        end

        documents << {
          link: {
            text: story["title"],
            path: story["href"]
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
