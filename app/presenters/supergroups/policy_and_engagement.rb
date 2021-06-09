module Supergroups
  class PolicyAndEngagement < Supergroup
    attr_reader :content

    def initialize
      super("policy_and_engagement")
    end

    def document_list(taxon_id)
      items = tagged_content(taxon_id)

      format_document_data(items)
    end

    def tagged_content(taxon_id)
      @content = MostRecentContent.fetch(content_id: taxon_id, filter_content_store_document_type: document_types)

      reorder_tagged_documents_to_prioritise_consultations
    end

    def consultation?(document_type)
      %w[open_consultation consultation_outcome closed_consultation].include?(
        document_type,
      )
    end

    def consultation_closing_date(consultation)
      date = Date.parse(consultation.end_date)

      if date < Time.zone.today
        return date.strftime("Date closed %d %B %Y")
      end

      date.strftime("Closing date %d %B %Y")
    end

  private

    def finder_path
      "/search/policy-papers-and-consultations"
    end

    def reorder_tagged_documents_to_prioritise_consultations
      consultations = @content.select do |content_item|
        consultation?(content_item.content_store_document_type)
      end

      other_document_types = @content - consultations

      consultations + other_document_types
    end

    def format_document_data(documents, data_category: "")
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            data_attributes: data_attributes(document.base_path, document.title, index),
          },
          metadata: {
            public_updated_at: document.public_updated_at,
            organisations: document.organisations,
            document_type: document.content_store_document_type.humanize,
          },
        }

        if consultation?(document.content_store_document_type)
          data[:metadata][:closing_date] = consultation_closing_date(document)
        end

        if data_category.present?
          data[:link][:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end
  end
end
