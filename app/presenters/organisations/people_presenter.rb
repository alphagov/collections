module Organisations
  class PeoplePresenter
    include OrganisationHelper
    include ApplicationHelper
    include ActionView::Helpers::UrlHelper

    def initialize(organisation)
      @org = organisation
      @allowed_role_content_ids = organisation.all_roles.map { |role| role["content_id"] }
    end

    def has_people?
      all_people.map { |people| people[:people] }.any?(&:present?)
    end

    def all_people
      all_people = @org.all_people.map do |person_type, people|
        {
          type: person_type,
          title: I18n.t("organisations.people.#{person_type}"),
          ga4_english_title: I18n.t("organisations.people.#{person_type}", locale: :en),
          lang: t_fallback("organisations.people.#{person_type}"),
          people: people.map { |person| formatted_person_data(person, person_type) },
        }
      end

      images_for_important_board_members(all_people)
    end

  private

    attr_reader :allowed_role_content_ids

    def images_for_important_board_members(people)
      people.map do |people_group|
        if people_group[:type].eql?(:board_members)
          people_group[:people].map.with_index(1) do |person, i|
            if @org.important_board_member_count && i > @org.important_board_member_count
              person.delete(:image_src)
              person.delete(:image_alt)
            end
          end
        end

        people_group
      end
    end

    def is_person_ministerial?(type)
      type.eql?(:ministers)
    end

    def expected_document_type(type)
      return "ministerial_role" if type == :ministers
      return "military_role" if type == :military_personnel
      return %w[board_member_role chief_scientific_advisor_role] if type == :board_members

      # for example: board_members -> board_member_role
      "#{type.to_s.delete_suffix('s')}_role"
    end

    def current_roles(person, type)
      person["links"].fetch("role_appointments", [])
        .select { |ra| ra["details"]["current"] }
        .map { |ra| ra["links"]["role"].first }
        .select { |role| allowed_role_content_ids.include?(role["content_id"]) }
        .select { |role| expected_document_type(type).include?(role["document_type"]) }
        .sort_by { |role| role["details"]["seniority"] }
    end

    def formatted_role_link(role)
      {
        text: role["title"],
        href: role["base_path"],
      }
    end

    def formatted_person_data(person, type)
      roles = current_roles(person, type)
      data = {
        brand: @org.brand,
        href: person["base_path"],
        description: nil,
        metadata: roles.map { |role| role["details"]["role_payment_type"] }.compact.first,
        heading_text: person["title"],
        lang: person["locale"],
        heading_level: 0,
        extra_details_no_indent: true,
      }

      if is_person_ministerial?(type)
        data[:extra_details] = roles.map { |role| formatted_role_link(role) }
      else
        data[:description] = roles.map { |role| role["title"] }.join(", ")
      end

      if (image = person["details"]["image"])
        data[:image_src] = image["url"]
      end

      data
    end
  end
end
