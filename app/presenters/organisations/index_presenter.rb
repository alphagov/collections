module Organisations
  class IndexPresenter
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
        agencies_and_other_public_bodies: @organisations.ordered_agencies_and_other_public_bodies,
        high_profile_groups: @organisations.ordered_high_profile_groups,
        public_corporations: @organisations.ordered_public_corporations,
        devolved_administrations: @organisations.ordered_devolved_administrations
      }
    end

    def works_with(organisation)
      if organisation["works_with"].present? && organisation["works_with"].any?
        works_with_count = child_organisations_count(organisation)
        works_with_text = "Works with #{works_with_count}"

        if works_with_count === 1
          works_with_text << " public body"
        elsif works_with_count > 1
          works_with_text << " agencies and public bodies"
        end
      end
    end
  end
end
