require 'active_model'

class Organisation
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def title
    @content_item.content_item_data["title"]
  end

  def acronym
    details["acronym"]
  end

  def organisation_type
    details["organisation_type"]
  end

  def organisation_featuring_priority
    details["organisation_featuring_priority"]
  end

  def brand
    return "prime-ministers-office-10-downing-street" if is_no_10?
    details["brand"]
  end

  def is_no_10?
    organisation_type == "executive_office"
  end

  def is_promotional_org?
    is_no_10? || organisation_type == "civil_service"
  end

  def logo
    details["logo"]
  end

  def crest
    logo["crest"]
  end

  def formatted_title
    logo["formatted_title"]
  end

  def body
    details["body"]
  end

  def organisation_image_url
    logo["image"]["url"] if logo["image"].present?
  end

  def organisation_image_alt_text
    logo["image"]["alt_text"] if logo["image"].present?
  end

  def web_url
    Plek.current.website_root + base_path
  end

  def slug
    base_path.gsub("/government/organisations/", "")
  end

  def ordered_featured_links
    details["ordered_featured_links"]
  end

  def translations
    content_item.content_item_data["links"]["available_translations"]
  end

  def base_path
    @content_item.content_item_data["base_path"]
  end

  def ordered_featured_documents
    details["ordered_featured_documents"]
  end

  def is_news_organisation?
    details["organisation_featuring_priority"] == "news"
  end

  def all_people
    {
      ministers: details["ordered_ministers"],
      military_personnel: details["ordered_military_personnel"],
      board_members: details["ordered_board_members"],
      traffic_commissioners: details["ordered_traffic_commissioners"],
      special_representatives: details["ordered_special_representatives"],
      chief_professional_officers: details["ordered_chief_professional_officers"]
    }
  end

  def ordered_featured_policies
    links["ordered_featured_policies"]
  end

  def social_media_links
    details["social_media_links"]
  end

  def foi_exempt?
    details["foi_exempt"]
  end

  def foi_contacts
    links["ordered_foi_contacts"]
  end

  def ordered_contacts
    links["ordered_contacts"]
  end

  def ordered_parent_organisations
    links["ordered_parent_organisations"]
  end

  def separate_website_url
    details["organisation_govuk_status"]["url"]
  end

  def ordered_high_profile_groups
    links["ordered_high_profile_groups"]
  end

private

  def links
    @content_item.content_item_data["links"]
  end

  def details
    @content_item.content_item_data["details"]
  end

  # methods below are not in use yet, this comment to be removed once confirmed

  def child_organisation_count
    links["ordered_child_organisations"].count
  end

  def ordered_corporate_information_pages
    details["ordered_corporate_information_pages"]
  end
end
