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

  def logo
    details["logo"]
  end

  def base_path
    @content_item.content_item_data["base_path"]
  end

  def ordered_featured_links
    details["ordered_featured_links"]
  end

  def body
    details["body"]
  end

  def ordered_featured_documents
    details["ordered_featured_documents"]
  end

  def child_organisation_count
    links["ordered_child_organisations"].count
  end

  def social_media_links
    details["social_media_links"]
  end

  def organisation_type
    details["organisation_type"].tr("_", " ")
  end

  def ordered_ministers
    details["ordered_ministers"]
  end

  def board_members
    details["ordered_board_members"]
  end

  def ordered_contacts
    links["ordered_contacts"]
  end

  def ordered_corporate_information_pages
    details["ordered_corporate_information_pages"]
  end

  def ordered_parent_organisations
    links["ordered_parent_organisations"]
  end

  def ordered_featured_policies
    links["ordered_featured_policies"]
  end

private

  def links
    @content_item.content_item_data["links"]
  end

  def details
    @content_item.content_item_data["details"]
  end
end
