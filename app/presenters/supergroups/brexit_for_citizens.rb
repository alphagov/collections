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
      /driving-abroad
      /get-a-child-passport/
      /government/collections/customs-vat-and-excise-regulations-leaving-the-eu-with-no-deal
      /government/collections/financial-services-legislation-under-the-eu-withdrawal-act
      /government/collections/how-to-prepare-if-the-uk-leaves-the-eu-with-no-deal
      /government/collections/information-for-the-health-and-care-sector-about-planning-for-a-potential-no-deal-brexit
      /government/consultations/regulating-co2-emission-standards-for-new-cars-and-vans-if-theres-no-brexit-deal
      /government/publications/accessing-animal-medicine-it-systems-if-theres-no-brexit-deal
      /government/publications/allocation-of-ecmt-haulage-permits-guidance-for-hauliers
      /government/publications/authorised-use-eligible-goods-and-authorised-uses
      /government/publications/aviation-safety-if-theres-no-brexit-deal
      /government/publications/aviation-security-if-theres-no-brexit-deal
      /government/publications/banking-insurance-and-other-financial-services-if-theres-no-brexit-deal
      /government/publications/breeding-animals-if-theres-no-brexit-deal
      /government/publications/brexit-and-competition-inquiry-cma-submission-to-lords-eu-committee
      /government/publications/brexit-and-consumer-protection-cma-submission-to-lords-eu-committee
      /government/publications/broadcasting-and-video-on-demand-if-theres-no-brexit-deal
      /government/publications/buying-and-selling-timber-if-theres-no-brexit-deal
      /government/publications/citizens-rights-uk-and-irish-nationals-in-the-common-travel-area
      /government/publications/classifying-labelling-and-packaging-chemicals-if-theres-no-brexit-deal
      /government/publications/commercial-fishing-if-theres-no-brexit-deal
      /government/publications/commercial-road-haulage-in-the-eu-if-theres-no-brexit-deal
      /government/publications/consumer-rights-if-theres-no-brexit-deal--2
      /government/publications/copyright-if-theres-no-brexit-deal
      /government/publications/data-protection-act-2018-overview
      /government/publications/data-protection-if-theres-no-brexit-deal
      /government/publications/driving-in-the-eu-if-theres-no-brexit-deal
      /government/publications/ensuring-blood-and-blood-products-are-safe-if-theres-no-brexit-deal
      /government/publications/erasmus-in-the-uk-if-theres-no-brexit-deal
      /government/publications/exhaustion-of-intellectual-property-rights-if-theres-no-brexit-deal
      /government/publications/exporting-animals-and-animal-products-if-theres-no-brexit-deal
      /government/publications/flights-to-and-from-the-uk-if-theres-no-brexit-deal
      /government/publications/generating-low-carbon-electricity-if-theres-no-brexit-deal
      /government/publications/geo-blocking-of-online-content-if-theres-no-brexit-deal
      /government/publications/handling-civil-legal-cases-that-involve-eu-countries-if-theres-no-brexit-deal
      /government/publications/health-marks-on-meat-fish-and-dairy-products-if-theres-no-brexit-deal
      /government/publications/how-medicines-medical-devices-and-clinical-trials-would-be-regulated-if-theres-no-brexit-deal
      /government/publications/implementation-period-what-it-means-for-the-life-sciences-sector
      /government/publications/importing-and-exporting-plants-if-theres-no-brexit-deal
      /government/publications/importing-animals-and-animal-products-if-theres-no-brexit-deal
      /government/publications/importing-high-risk-food-and-animal-feed-if-theres-no-brexit-deal--2
      /government/publications/labelling-tobacco-products-and-e-cigarettes-if-theres-no-brexit-deal
      /government/publications/list-of-goods-applicable-to-oral-and-by-conduct-declarations
      /government/publications/meeting-climate-change-requirements-if-theres-no-brexit-deal
      /government/publications/meeting-rail-safety-and-standards-if-theres-no-brexit-deal
      /government/publications/merger-review-and-anti-competitive-activity-if-theres-no-brexit-deal
      /government/publications/mobile-roaming-if-theres-no-brexit-deal
      /government/publications/operating-bus-or-coach-services-abroad-if-theres-no-brexit-deal
      /government/publications/patents-if-theres-no-brexit-deal
      /government/publications/plant-variety-rights-and-marketing-of-seed-and-propagating-material-if-theres-no-brexit-deal
      /government/publications/producing-and-labelling-food-if-theres-no-brexit-deal
      /government/publications/producing-and-processing-organic-food-if-theres-no-brexit-deal
      /government/publications/proposal-for-a-temporary-transitional-power-to-be-exercised-by-uk-regulators
      /government/publications/protecting-geographical-food-and-drink-names-if-theres-no-brexit-deal
      /government/publications/providing-services-including-those-of-a-qualified-professional-if-theres-no-brexit-deal
      /government/publications/quality-and-safety-of-organs-tissues-and-cells-if-theres-no-brexit-deal
      /government/publications/rail-transport-if-theres-no-brexit-deal
      /government/publications/recognition-of-seafarer-certificates-of-competency-if-theres-no-brexit-deal
      /government/publications/registration-of-veterinary-medicines-if-theres-no-brexit-deal
      /government/publications/regulating-biocidal-products-if-theres-no-brexit-deal
      /government/publications/regulating-pesticides-if-theres-no-brexit-deal
      /government/publications/regulation-of-veterinary-medicines-if-theres-no-brexit-deal
      /government/publications/road-haulage-and-driving-in-the-eu-post-brexit
      /government/publications/satellites-and-space-programmes-if-theres-no-brexit-deal
      /government/publications/state-aid-if-theres-no-brexit-deal
      /government/publications/submitting-regulatory-information-on-medical-products-if-theres-no-brexit-deal
      /government/publications/taking-horses-abroad-if-theres-no-brexit-deal--2
      /government/publications/taking-your-pet-abroad-if-theres-no-brexit-deal
      /government/publications/the-governments-guarantee-for-eu-funded-programmes-if-theres-no-brexit-deal
      /government/publications/trade-marks-and-designs-if-theres-no-brexit-deal
      /government/publications/trading-and-moving-endangered-species-protected-by-cites-if-theres-no-brexit-deal
      /government/publications/trading-goods-regulated-under-the-new-approach-if-theres-no-brexit-deal
      /government/publications/trading-in-drug-precursors-if-theres-no-brexit-deal
      /government/publications/trading-under-the-mutual-recognition-principle-if-theres-no-brexit-deal
      /government/publications/trading-with-the-eu-if-theres-no-brexit-deal
      /government/publications/travelling-in-the-common-travel-area-if-theres-no-brexit-deal
      /government/publications/travelling-to-the-eu-with-a-uk-passport-if-theres-no-brexit-deal
      /government/publications/travelling-with-a-european-firearms-pass-if-theres-no-brexit-deal
      /government/publications/uk-governments-preparations-for-a-no-deal-scenario
      /government/publications/upholding-environmental-standards-if-theres-no-brexit-deal
      /government/publications/vehicle-insurance-if-theres-no-brexit-deal
      /government/publications/vehicle-type-approval-if-theres-no-brexit-deal
      /government/publications/workplace-rights-if-theres-no-brexit-deal
      /guidance/ecmt-international-road-haulage-permits
      /guidance/eu-community-licences-for-international-road-haulage
      /guidance/exiting-the-european-union
      /guidance/international-authorisations-and-permits-for-road-haulage
      /guidance/medicines-supply-contingency-planning-programme
      /guidance/passport-rules-for-travel-to-europe-after-brexit
      /guidance/pet-travel-to-europe-after-brexit
      /guidance/prepare-to-drive-in-the-eu-after-brexit
      /renew-adult-passport/
      /settled-status-eu-citizens-families/what-settled-and-presettled-status-means
      /take-pet-abroad
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
