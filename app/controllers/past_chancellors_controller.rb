class PastChancellorsController < ApplicationController
  def index
    content_item = YAML.load_file(Rails.root.join("config/past_chancellors/content_item.yml"))
    @index_page = HistoricAppointmentsIndex.new(ContentItem.new(content_item))
    setup_content_item_and_navigation_helpers(@index_page)
  end
end
