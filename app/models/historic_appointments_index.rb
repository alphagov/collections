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
  def selection_of_profiles
    @content_item.content_item_data.dig("body", "selection_of_profiles")
  end

  def centuries_data
    @content_item.content_item_data.dig("body", "centuries")
                 .map { |key, value| [ I18n.t("historic_appointments_index.headings.#{key}"), value.deep_symbolize_keys ] }
                 .to_h
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end
end
