module Supergroups
  class BrexitForCitizens < Supergroup
    include RummagerFields

    attr_reader :content

    def initialize
      super('brexit-citizens')
    end

    def tagged_content(taxon_id)
      @content = search_response_including_brexit(taxon_id, document_types, 30)
                   .documents
                   .select { |document| BASE_PATHS.include?(document.base_path) }
                   .first(3)
    end

  private

    BASE_PATHS = %w(
      /government/publications/allocation-of-ecmt-haulage-permits-guidance-for-hauliers
      /government/publications/aviation-safety-if-theres-no-brexit-deal
      /government/publications/aviation-security-if-theres-no-brexit-deal
      /government/publications/banking-insurance-and-other-financial-services-if-theres-no-brexit-deal
      /government/publications/breeding-animals-if-theres-no-brexit-deal
      /government/publications/broadcasting-and-video-on-demand-if-theres-no-brexit-deal
      /government/publications/citizens-rights-uk-and-irish-nationals-in-the-common-travel-area
      /government/publications/commercial-road-haulage-in-the-eu-if-theres-no-brexit-deal
      /government/publications/consumer-rights-if-theres-no-brexit-deal--2
      /government/publications/data-protection-if-theres-no-brexit-deal
      /government/publications/driving-in-the-eu-if-theres-no-brexit-deal
      /government/publications/erasmus-in-the-uk-if-theres-no-brexit-deal
      /government/publications/flights-to-and-from-the-uk-if-theres-no-brexit-deal
      /government/publications/geo-blocking-of-online-content-if-theres-no-brexit-deal
      /government/publications/mobile-roaming-if-theres-no-brexit-deal
      /government/publications/providing-services-including-those-of-a-qualified-professional-if-theres-no-brexit-deal
      /government/publications/rail-transport-if-theres-no-brexit-deal
      /government/publications/recognition-of-seafarer-certificates-of-competency-if-theres-no-brexit-deal
      /government/publications/taking-horses-abroad-if-theres-no-brexit-deal--2
      /government/publications/taking-your-pet-abroad-if-theres-no-brexit-deal
      /government/publications/travelling-in-the-common-travel-area-if-theres-no-brexit-deal
      /government/publications/travelling-to-the-eu-with-a-uk-passport-if-theres-no-brexit-deal
      /government/publications/travelling-with-a-european-firearms-pass-if-theres-no-brexit-deal
      /government/publications/uk-governments-preparations-for-a-no-deal-scenario
      /government/publications/upholding-environmental-standards-if-theres-no-brexit-deal
      /government/publications/vehicle-insurance-if-theres-no-brexit-deal
      /government/publications/workplace-rights-if-theres-no-brexit-deal
      /guidance/ecmt-international-road-haulage-permits
      /guidance/eu-community-licences-for-international-road-haulage
      /guidance/exiting-the-european-union
      /guidance/international-authorisations-and-permits-for-road-haulage
      /guidance/passport-rules-for-travel-to-europe-after-brexit
      /guidance/pet-travel-to-europe-after-brexit
      /guidance/prepare-to-drive-in-the-eu-after-brexit
    )

    def search_response_including_brexit(content_id, filter_content_store_document_type, number_of_links = 5)
      params = {
        start: 0,
        count: number_of_links,
        fields: RummagerFields::TAXON_SEARCH_FIELDS,
        filter_all_part_of_taxonomy_tree: [content_id, 'd6c2de5d-ef90-45d1-82d4-5f2438369eea'],
        order: '-popularity',
        filter_content_store_document_type: filter_content_store_document_type,
      }

      RummagerSearch.new(params)
    end

    def format_document_data(documents, data_category = "")
      documents.each.with_index(1).map do |document, index|
        data = {
          text: document.title,
          path: document.base_path,
          data_attributes: data_attributes(document.base_path, document.title, index)
        }

        if data_category.present?
          data[:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end

    def document_types
      GovukDocumentTypes.supergroup_document_types('guidance_and_regulation', 'services')
    end
  end
end
