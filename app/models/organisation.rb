require 'active_model'

class Organisation
  include ActiveModel::Model

  attr_accessor(
      :title,
      :content_id,
      :link,
      :slug,
      :organisation_state,
      :document_count
  )

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
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
    case organisation_id
    when "ordered_ministrial_departments"
      "Ministerial departments"
    else
      "Not yet named"
    end
  end

  def live?
    organisation_state == 'live'
  end
end
