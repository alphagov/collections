module Organisations
  # DocumentPresenter transforms a raw rummager result into a format
  # required by the govuk_publishing_components document_list component.
  #
  # See https://govuk-publishing-components.herokuapp.com/component-guide/document_list
  class DocumentPresenter
    attr_accessor :include_metadata

    def initialize(rummager_result, include_metadata: true)
      @raw_document = rummager_result
      @include_metadata = include_metadata
    end

    def present
      {
        link: {
          text: @raw_document["title"],
          path: @raw_document["link"],
        },
      }.merge(present_metadata)
    end

    def present_metadata      
      if include_metadata
        {
          metadata: {
            public_updated_at: public_updated_at,
            document_type: document_type,
          },
        }
      else
        {}
      end
    end

  private

    def document_type
      type = @raw_document["content_store_document_type"]

      return if type.blank?

      document_type = I18n.t("organisations.content_item.schema_name.#{type}.one")

      # Handle document types with acronyms
      document_acronyms = %w[Foi Dfid Aaib Cma Esi Hmrc Html Maib Raib Utaac]
      document_acronyms.each do |acronym|
        document_type.gsub!(acronym, acronym.upcase)
      end

      document_type
    end

    def public_updated_at
      timestamp = @raw_document["public_timestamp"]
      timestamp ? Date.parse(timestamp) : nil
    end
  end
end
