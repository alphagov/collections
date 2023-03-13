require "active_model"

class HistoricAppointmentsIndex
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def centuries_data
    @content_item.dig("body", "centuries")
                 .transform_keys { |key| I18n.t("historic_appointments_index.headings.#{key}") }
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end
end
