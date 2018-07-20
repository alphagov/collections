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

  def organisation_featuring_priority
    details["organisation_featuring_priority"]
  end

  def brand
    return slug if is_no_10?
    details["brand"]
  end

  def is_no_10?
    slug == "prime-ministers-office-10-downing-street"
  end

  def is_promotional_org?
    is_no_10? || organisation_type == "civil_service"
  end

  def is_dfid?
    title == "Department for International Development"
  end

  def is_sub_organisation?
    organisation_type == "sub_organisation"
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

  def slug_with_locale
    base_path.gsub("/government/organisations/", "")
  end

  def slug
    File.basename(slug_with_locale, File.extname(slug_with_locale))
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

  def important_board_member_count
    details["important_board_members"]
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

  def no_website?
    separate_website_url.blank?
  end

  def is_live?
    details["organisation_govuk_status"]["status"] == "live"
  end

  def is_changed_name?
    details["organisation_govuk_status"]["status"] == "changed_name"
  end

  def is_exempt?
    details["organisation_govuk_status"]["status"] == "exempt"
  end

  def is_joining?
    details["organisation_govuk_status"]["status"] == "joining"
  end

  def is_devolved?
    details["organisation_govuk_status"]["status"] == "devolved"
  end

  def is_closed?
    details["organisation_govuk_status"]["status"] == "closed"
  end

  def is_left_gov?
    details["organisation_govuk_status"]["status"] == "left_gov"
  end

  def is_merged?
    details["organisation_govuk_status"]["status"] == "merged"
  end

  def is_split?
    details["organisation_govuk_status"]["status"] == "split"
  end

  def is_no_longer_exists?
    details["organisation_govuk_status"]["status"] == "no_longer_exists"
  end

  def is_replaced?
    details["organisation_govuk_status"]["status"] == "replaced"
  end

  def status_updated_at
    details["organisation_govuk_status"]["updated_at"]
  end

  def ordered_successor_organisations
    links["ordered_successor_organisations"]
  end

  def ordered_high_profile_groups
    links["ordered_high_profile_groups"]
  end

  def ordered_corporate_information
    details["ordered_corporate_information_pages"]
  end

  def secondary_corporate_information
    details["secondary_corporate_information_pages"]
  end

  def ordered_promotional_features
    details["ordered_promotional_features"]
  end

private

  def links
    @content_item.content_item_data["links"]
  end

  def details
    @content_item.content_item_data["details"]
  end

  def organisation_type
    details["organisation_type"]
  end
end
