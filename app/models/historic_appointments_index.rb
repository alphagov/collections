require "active_model"

class HistoricAppointmentsIndex
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def title
    @content_item.content_item_data["title"]
  end

  def centuries_data
    @content_item.content_item_data.dig("body", "centuries")
  end

  def selection_of_profiles
    @content_item.content_item_data.dig("body", "selection_of_profiles")
  end

  def self.find!(base_path)
    directory =
      base_path.include?("past-foreign-secretaries") ? "past_foreign_secretaries" : "past_chancellors"
    yaml_content = YAML.load_file(Rails.root.join("config/#{directory}/content_item.yml"))
    new(ContentItem.new(yaml_content))
  end
end
