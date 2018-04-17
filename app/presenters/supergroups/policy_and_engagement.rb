module Supergroups
  class PolicyAndEngagement < Supergroup
    attr_reader :content

    def initialize
      super('policy_and_engagement')
    end

    def document_list(taxon_id)
      tagged_content(taxon_id).each.map do |document|
        data = {
          link: {
            text: document.title,
            path: document.base_path
          },
          metadata: {
            public_updated_at: document.public_updated_at,
            organisations: document.organisations,
            document_type: document.content_store_document_type.humanize
          }
        }

        if consultation?(document.content_store_document_type)
          data[:metadata][:closing_date] = consultation_closing_date(document.base_path)
        end

        data
      end
    end

    def tagged_content(taxon_id)
      @content = MostRecentContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: @name)

      @content.select { |content_item| consultation?(content_item.content_store_document_type) } | @content
    end

    def consultation?(document_type)
      document_type == 'open_consultation' ||
        document_type == 'consultation_outcome' ||
        document_type == 'closed_consultation'
    end

    def promoted_content_count(taxon_id)
      consultation_count = tagged_content(taxon_id).count do |content_item|
        consultation?(content_item.content_store_document_type)
      end

      return 3 if consultation_count > 3

      consultation_count
    end

    def consultation_closing_date(base_path)
      @consultation = ::Services.content_store.content_item(base_path)
      date = Date.parse(@consultation["details"]["closing_date"])
      date.strftime("%d %B %Y")
    end
  end
end
