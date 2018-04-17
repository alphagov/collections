module Supergroups
  class PolicyAndEngagement < Supergroup
    attr_reader :content

    def initialize
      super('policy_and_engagement')
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

    def special_format_count(taxon_id)
      consultation_count = tagged_content(taxon_id).count do |content_item|
        consultation?(content_item.content_store_document_type)
      end

      return 3 if consultation_count > 3

      consultation_count
    end
  end
end
