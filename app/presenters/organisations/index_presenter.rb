module Organisations
  class IndexPresenter
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include OrganisationsHelper

    def initialize(organisations)
      @organisations = organisations
    end

    def title
      @organisations.content_item.title
    end

    def all_organisations
      {
        number_10: @organisations.number_10,
        ministerial_departments: @organisations.ministerial_departments,
        non_ministerial_departments: @organisations.non_ministerial_departments,
        agencies_and_other_public_bodies: @organisations.agencies_and_other_public_bodies,
        high_profile_groups: @organisations.high_profile_groups,
        public_corporations: @organisations.public_corporations,
        devolved_administrations: @organisations.devolved_administrations,
      }
    end

    def works_with_statement(organisation)
      if organisation["works_with"].present? && organisation["works_with"].any?
        works_with_count = child_organisations_count(organisation)
        works_with_text = "Works with #{works_with_count}"

        if works_with_count == 1
          works_with_text << " public body"
        elsif works_with_count > 1
          works_with_text << " agencies and public bodies"
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
