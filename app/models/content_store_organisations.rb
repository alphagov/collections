require "active_model"

class ContentStoreOrganisations
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def live?
    organisation_state == "live"
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def number_10
    details["ordered_executive_offices"]
  end

  def number_10?(organisation_type)
    organisation_type == "Executive offices"
  end

  def ministerial_departments
    details["ordered_ministerial_departments"]
  end

  def non_ministerial_departments
    details["ordered_non_ministerial_departments"]
  end

  def agencies_and_other_public_bodies
    details["ordered_agencies_and_other_public_bodies"]
  end

  def high_profile_groups
    details["ordered_high_profile_groups"]
  end

  def public_corporations
    details["ordered_public_corporations"]
  end

  def devolved_administrations
    details["ordered_devolved_administrations"]
  end

  def count_by_type(organisation_type)
    details[organisation_type].count
  end

  def organisations_list(department_type)
    details[department_type]
  end

  def category_name_from_type(category_type)
    I18n.t("organisations.type.#{category_type}")
  end

private

  def details
    @content_item.content_item_data["details"]
  end
end
