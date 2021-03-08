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
    current_roles.map { |role| role["title"] }.to_sentence
  end

  def previous_roles_items
    previous_roles.map do |role|
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

  def has_previous_roles?
    previous_roles.present?
  end

  def image_url
    details.dig("image", "url")
  end

  def biography
    details["body"]
  end

  def announcements
    @announcements ||= AnnouncementsPresenter.new(slug, filter_key: "people")
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

  def role_appointments(current:)
    links
      .fetch("role_appointments", [])
      .filter { |role_appointment| role_appointment.dig("details", "current") == current }
      .sort_by { |role_appointment| role_appointment.dig("details", "person_appointment_order") }
  end

  def current_role_appointments
    @current_role_appointments ||= role_appointments(current: true)
  end

  def previous_role_appointments
    @previous_role_appointments ||= role_appointments(current: false)
  end

  def previous_roles
    previous_role_appointments
      .sort_by { |role_appointment| role_appointment["details"]["started_on"] }
      .reverse
      .map do |role_appointment|
        role_appointment["links"]["role"].first.tap do |role|
          role["start_year"] = Time.zone.parse(role_appointment["details"]["started_on"]).strftime("%Y")
          role["end_year"] = Time.zone.parse(role_appointment["details"]["ended_on"]).strftime("%Y")
        end
      end
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
end
