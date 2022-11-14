module Organisations
  # DocumentPresenter transforms a raw search_api result into a format
  # required by the govuk_publishing_components document_list component.
  #
  # See https://govuk-publishing-components.herokuapp.com/component-guide/document_list
  class DocumentPresenter
    include ApplicationHelper
    attr_accessor :include_metadata

    def initialize(search_api_result, include_metadata: true)
      @raw_document = search_api_result
      @include_metadata = include_metadata
    end

    def present
      {
        link: {
          text: @raw_document["title"],
          path: @raw_document["link"],
          locale: "en",
        },
      }.merge(present_metadata)
    end

    def present_metadata
      if include_metadata
        {
          metadata: {
            public_updated_at:,
            document_type:,
            locale: {
              public_updated_at: t_fallback(:"date.month_names"),
              document_type: t_fallback(document_translation),
            },
          },
        }
      else
        {}
      end
    end

  private

    def document_type
      return if document_translation.blank?

      document_type = I18n.t(document_translation, default: cleaned_document_type.titleize.gsub("_", " "))

      # Handle document types with acronyms
      document_acronyms = %w[Foi Dfid Aaib Cma Esi Hmrc Html Maib Raib Utaac Oim]
      document_acronyms.each do |acronym|
        document_type.gsub!(acronym, acronym.upcase)
      end

      document_type
    end

    def cleaned_document_type
      type = @raw_document["content_store_document_type"]

      return if type.blank?

      type.downcase.gsub(" ", "_")
    end

    def document_translation
      return if cleaned_document_type.blank?

      "shared.schema_name.#{cleaned_document_type}.one"
    end

    def public_updated_at
      timestamp = @raw_document["public_timestamp"]
      timestamp ? Date.parse(timestamp) : nil
    end
  end
end
