require 'active_model'

class ContentStoreOrganisation
  include ActiveModel::Model

  attr_accessor(
    :title,
    :content_id,
    :link,
    :slug,
    :organisation_state,
    :document_count,
    :logo_formatted_title,
    :brand,
    :crest,
    :logo_url
  )

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def live?
    organisation_state == 'live'
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def organisations_count(department_type)
    @content_item.content_item_data["details"][department_type].count
  end

  def organisations_list(department_type)
    @content_item.content_item_data["details"][department_type]
  end

  def organisation_department_count(organisation)
    organisation["works_with"].flatten.count
  end

  def get_name_of_organisation(organisation_id)
    org_name = {
        "ordered_executive_offices" => "",
        "ordered_ministerial_departments" => "Ministerial departments",
        "ordered_non_ministerial_departments" => "Non ministerial departments",
        "ordered_agencies_and_other_public_bodies" => "Agencies and other public bodies",
        "ordered_high_profile_groups" => "High profile groups",
        "ordered_public_corporations" => "Public corporations",
        "ordered_devolved_administrations" => "Devolved administrations"
    }
    org_name[organisation_id]
  end

  def get_name_of_department_category(category_id)
    org_name = {
        "executive_office" => "",
        "ministerial_department" => "Ministerial department",
        "executive_agency" => "Executive agency",
        "executive_ndpb" => "Executive non-departmental public body",
        "advisory_ndpb" => "Advisory non-departmental public body",
        "other" => "Other",
        "civil_service" => "Civil Service",
        "non_ministerial_department" => "Non-ministerial department",
        "tribunal_ndpb" => "Tribunal non-departmental public body",
        "public_corporation" => "Public corporation"
    }
    org_name[category_id]
  end

  def has_logo?
    crest.present? && crest != 'no-identity' && !custom_logo?
  end

  def custom_logo?
    crest == 'custom' && logo_url.present?
  end
end
