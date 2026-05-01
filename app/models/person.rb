require "active_model"

class Person
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def base_path
    @content_item.content_item_data["base_path"]
  end

  def title
    @content_item.content_item_data["title"]
  end

  def current_roles_title
    current_roles.map { |role| role["title"] }.to_sentence(locale: content_item.locale)
  end

  def previous_non_ministerial_roles_items
    formatted_previous_non_ministerial_roles.map do |role|
      {
        link: {
          text: role["title"],
          path: role["base_path"],
        },
        metadata: {
          appointment_duration: "#{role['start_year']} to #{role['end_year']}",
        },
      }
    end
  end

  def has_previous_non_ministerial_roles?
    formatted_previous_non_ministerial_roles.present?
  end

  def image_url
    details.dig("image", "url")
  end

  def biography
    details["body"]
  end

  def announcements
    @announcements ||=
      current_roles.reduce({}) { |hash, role|
        hash[role["title"]] = AnnouncementsPresenter.new(role["base_path"].split("/").last, slug_prefix: "ministers", filter_key: "roles")
        hash
      }
  end

  def translations
    available_translations.map do |translation|
      translation
        .slice(:locale, :base_path)
        .merge(
          text: language_name(translation[:locale]),
          active: locale == translation[:locale],
        )
    end
  end

  def currently_in_a_role?
    current_role_appointments.any?
  end

  def current_roles
    current_role_appointments
        .map { |appointment| appointment["links"]["role"].first }
  end

  def locale
    @content_item.content_item_data["locale"]
  end

private

  def slug
    base_path.split("/").last
  end

  def role_appointments
    @role_appointments ||= links.fetch("role_appointments", [])
  end

  def sort_by_appointment_order(appointments)
    appointments.sort_by { |role_appointment| role_appointment.dig("details", "person_appointment_order") }
  end

  def role_appointment(current:)
    sort_by_appointment_order(
      role_appointments.filter { |role_appointment| role_appointment.dig("details", "current") == current },
    )
  end

  def current_role_appointments
    @current_role_appointments ||= role_appointment(current: true)
  end

  def previous_role_appointments
    @previous_role_appointments ||= role_appointment(current: false)
  end

  def previous_non_ministerial_roles
    @previous_non_ministerial_roles ||=
      sort_by_appointment_order(
        role_appointments
          .filter { |role_appointment| role_appointment.dig("details", "ended_on").present? }
          .filter { |role_appointment| non_ministerial_role?(role_appointment) },
      )
  end

  def formatted_previous_non_ministerial_roles
    @formatted_previous_non_ministerial_roles ||=
      previous_non_ministerial_roles
        .sort_by { |role_appointment| role_appointment.dig("details", "started_on") }
        .reverse
        .map { |role_appointment| format_role_with_dates(role_appointment) }
  end

  def links
    @content_item.content_item_data["links"]
  end

  def details
    @content_item.content_item_data["details"]
  end

  def language_name(language)
    I18n.t("shared.language_name", locale: language)
  end

  def available_translations
    links["available_translations"]&.map(&:symbolize_keys) || []
  end

  def non_ministerial_role?(role_appointment)
    role = role_from_appointment(role_appointment)
    role && role["document_type"] != "ministerial_role"
  end

  def role_from_appointment(appointment)
    appointment.dig("links", "role", 0)
  end

  def format_role_with_dates(role_appointment)
    role_from_appointment(role_appointment).tap do |role|
      role["start_year"] = format_year(role_appointment.dig("details", "started_on"))
      role["end_year"] = format_year(role_appointment.dig("details", "ended_on"))
    end
  end

  def format_year(date_string)
    Time.zone.parse(date_string).strftime("%Y")
  end
end
