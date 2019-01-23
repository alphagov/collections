module Organisations
  # DocumentPresenter transforms a raw rummager result into a format
  # required by the govuk_publishing_components document_list component.
  #
  # See https://govuk-publishing-components.herokuapp.com/component-guide/document_list
  class DocumentPresenter
    def initialize(rummager_result)
      @raw_document = rummager_result
    end

    def present
      {
        link: {
          text: @raw_document["title"],
          path: @raw_document["link"]
        },
        metadata: {
          public_updated_at: public_updated_at,
          document_type: document_type
        }
      }
    end

  private

    def document_type
      type = @raw_document["content_store_document_type"]

      return unless type.present?

      document_type = type.capitalize.tr("_", " ")

      # Handle document types with acronyms
      document_acronyms = %w{Foi Dfid Aaib Cma Esi Hmrc Html Maib Raib Utaac}
      document_acronyms.each { |acronym|
        document_type.gsub!(acronym, acronym.upcase)
      }

      document_type
    end

    def public_updated_at
      timestamp = @raw_document["public_timestamp"]
      timestamp ? Date.parse(timestamp) : nil
    end
  end
end
