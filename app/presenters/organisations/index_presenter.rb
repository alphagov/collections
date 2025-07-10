module Organisations
  class IndexPresenter
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include OrganisationsSupport

    LISTING_ORDER = %w[
      executive_office
      ministerial_department
      non_ministerial_department
      executive_agency
      executive_ndpb
      advisory_ndpb
      special_health_authority
      tribunal
      public_corporation
      independent_monitoring_body
      adhoc_advisory_group
      devolved_administration
      sub_organisation
      other
      civil_service
      court
    ].freeze

    def initialize(organisations)
      @organisations = organisations
    end

    def title
      @organisations.content_item.title
    end

    def filter_terms(organisation_type, organisation)
      acronym = organisation["acronym"]
      title = ministerial_organisation?(organisation_type) ? organisation["logo"]["formatted_title"].squish : organisation["title"]

      [title, acronym].compact.join(" ")
    end

    def all_organisations
      {
        number_10: ordered_executive_offices(
          @organisations.number_10
        ), #number_10 is any executive office
        ministerial_departments: reject_joining_organisations(
          @organisations.ministerial_departments,
        ),
        non_ministerial_departments: reject_joining_organisations(
          @organisations.non_ministerial_departments,
        ),
        agencies_and_other_public_bodies: reject_joining_organisations(
          @organisations.agencies_and_other_public_bodies,
        ),
        high_profile_groups: @organisations.high_profile_groups,
        public_corporations: @organisations.public_corporations,
        devolved_governments: @organisations.devolved_administrations,
      }
    end

    def organisations_with_works_with_statement
      count = 0
      all_organisations.each_value do |organisations|
        organisations.each do |organisation|
          count += 1 if works_with_statement(organisation)
        end
      end
      count
    end

    def ordered_works_with(organisation)
      non_joining_works_with_categorised_links(organisation, @organisations.by_href)
        .to_a
        .sort_by { |type, _departments| LISTING_ORDER.index(type) || 999 }
    end

    def ordered_executive_offices(organisations)
      # organisations.reverse
      organisations.sort_by do |org|
        org["slug"] == "prime-ministers-office-10-downing-street" ? [0, org["slug"]] : [1, org["slug"]]
      end
    end

    def works_with_statement(organisation)
      if organisation["works_with"].present? && organisation["works_with"].any?
        works_with_count = non_joining_works_with_links_count(organisation, @organisations.by_href)
        if works_with_count == 1
          I18n.t("organisations.works_with_statement.one", works_with_count:)
        elsif works_with_count > 1
          I18n.t("organisations.works_with_statement.other", works_with_count:)
        end
      end
    end

    def executive_office?(organisation_type)
      organisation_type.eql?(:number_10)
    end

    def ministerial_organisation?(organisation_type)
      executive_office?(organisation_type) || organisation_type.eql?(:ministerial_departments)
    end
  end
end
