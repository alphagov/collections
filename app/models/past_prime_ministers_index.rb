require "active_model"

class PastPrimeMinistersIndex
  include ActiveModel::Model

  attr_accessor :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def pms_with_historical_accounts
    @content_item.content_item_data.dig("links", "historical_accounts")
              .sort_by! { |pm| -pm.dig("details", "dates_in_office").last["start_year"] }
  end

  def pms_without_historical_accounts
    @content_item.content_item_data.dig("details", "appointments_without_historical_accounts")
                                   .sort_by! { |pm| -pm["dates_in_office"].last["start_year"] }
  end
end
