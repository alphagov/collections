module Organisations
  class IndexPresenter
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include OrganisationsHelper

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

    def all_organisations
      {
        number_10: @organisations.number_10,
        ministerial_departments: filter_not_joining(
          @organisations.ministerial_departments,
        ),
        non_ministerial_departments: filter_not_joining(
          @organisations.non_ministerial_departments,
        ),
        agencies_and_other_public_bodies: filter_not_joining(
          @organisations.agencies_and_other_public_bodies,
        ),
        high_profile_groups: @organisations.high_profile_groups,
        public_corporations: @organisations.public_corporations,
        devolved_administrations: @organisations.devolved_administrations,
      }
    end

    def filter_not_joining(organisations)
      organisations.filter do |organisation|
        organisation["govuk_status"] != "joining"
      end
    end

    def ordered_works_with(organisation)
      organisation.fetch("works_with", []).to_a.sort_by { |type, _departments| LISTING_ORDER.index(type) || 999 }
    end

    def works_with_statement(organisation)
      if organisation["works_with"].present? && organisation["works_with"].any?
        works_with_count = child_organisations_count(organisation)
        if works_with_count == 1
          I18n.t("organisations.works_with_statement.one", works_with_count: works_with_count)
        elsif works_with_count > 1
          I18n.t("organisations.works_with_statement.other", works_with_count: works_with_count)
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
