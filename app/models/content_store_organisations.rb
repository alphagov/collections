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

  # executive_offices
  def number_10
    [
      {
      "acronym"=>"Test",
      "analytics_identifier"=>"OT123",
      "brand"=>"office-of-test",
      "child_organisations"=>[],
      "closed_at"=>nil,
      "content_id"=>"705dbea4-8bd7-422e-ba9c-254557f77f81",
      "format"=>"Executive office",
      "govuk_closed_status"=>"",
      "govuk_status"=>"live",
      "href"=>"/government/organisations/office-of-test",
      "logo"=>{"crest"=>"eo",
      "formatted_title"=>"Office of Test Example"},
      "parent_organisations"=>[{"href"=>"/government/organisations/cabinet-office", "title"=>"Cabinet Office"}],
      "separate_website"=>false,
      "slug"=>"office-of-test",
      "superseded_organisations"=>[],
      "superseding_organisations"=>[],
      "title"=>"Prime Minister's Office, 10 Downing Street",
      "updated_at"=>"2025-07-01T15:02:39.000+01:00",
      "works_with"=>{}
    },
    {
      "acronym"=>"Number 10",
      "analytics_identifier"=>"OT532",
      "brand"=>"prime-ministers-office-10-downing-street",
      "child_organisations"=>[],
      "closed_at"=>nil,
      "content_id"=>"705dbea4-8bd7-422e-ba9c-254557f77f81",
      "format"=>"Executive office",
      "govuk_closed_status"=>"",
      "govuk_status"=>"live",
      "href"=>"/government/organisations/prime-ministers-office-10-downing-street",
      "logo"=>{"crest"=>"eo", "formatted_title"=>"Prime Minister's Office \r\n10 Downing Street"},
      "parent_organisations"=>[{"href"=>"/government/organisations/cabinet-office", "title"=>"Cabinet Office"}],
      "separate_website"=>false,
      "slug"=>"prime-ministers-office-10-downing-street",
      "superseded_organisations"=>[],
      "superseding_organisations"=>[],
      "title"=>"Prime Minister's Office, 10 Downing Street",
      "updated_at"=>"2024-07-16T15:02:39.000+01:00", "works_with"=>{}
      }
    ]
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

  def all
    @all ||= [
      *number_10,
      *ministerial_departments,
      *non_ministerial_departments,
      *agencies_and_other_public_bodies,
      *high_profile_groups,
      *public_corporations,
      *devolved_administrations,
    ]
  end

  def by_href
    @by_href ||= all.index_by do |organisation|
      organisation["href"]
    end
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
