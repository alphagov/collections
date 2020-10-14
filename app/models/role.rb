require "active_model"

class Role
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
    content_item_data["base_path"]
  end

  def title
    content_item_data["title"]
  end

  def responsibilities
    details["body"]
  end

  def organisations
    links["ordered_parent_organisations"]
  end

  def currently_occupied?
    current_holder.present?
  end

  def current_holder
    @current_holder ||= role_holders(current: true)
      .first
      &.dig("links", "person")
      &.first
  end

  def current_holder_biography
    current_holder["details"]["body"]
  end

  def past_holders
    @past_holders ||= role_holders(current: false)
      .reverse
      .map do |rh|
        rh.dig("links", "person")
          &.first
          &.tap do |hash|
            hash["details"]["start_year"] = Time.zone.parse(rh["details"]["started_on"]).year
            hash["details"]["end_year"] = Time.zone.parse(rh["details"]["ended_on"]).year
          end
      end
  end

  def link_to_person
    current_holder["base_path"]
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

  def locale
    content_item_data["locale"]
  end

  def announcements
    @announcements ||= AnnouncementsPresenter.new(slug, slug_prefix: "ministers", filter_key: "roles")
  end

  def supports_historical_accounts?
    details["supports_historical_accounts"]
  end

  def past_holders_url
    if slug == "prime-minister"
      "/government/history/past-prime-minister"
    elsif slug == "chancellor-of-the-exchequer"
      "/government/history/past-chancellors"
    elsif slug == "secretary-of-state-for-foreign-commonwealth-and-development-affairs"
      "/government/history/past-foreign-secretaries"
    elsif slug == "foreign-secretary"
      "/government/history/past-foreign-secretaries"
    end
  end

private

  def content_item_data
    content_item.content_item_data
  end

  def links
    content_item_data["links"]
  end

  def details
    content_item_data["details"]
  end

  def language_name(language)
    I18n.t("shared.language_names.#{language}")
  end

  def available_translations
    links["available_translations"].map(&:symbolize_keys)
  end

  def slug
    base_path.split("/").last
  end

  def role_holders(current:)
    links.fetch("role_appointments", [])
      .find_all { |rh| rh["details"]["current"] == current }
      .sort_by { |rh| rh["details"]["started_on"] }
  end
end
