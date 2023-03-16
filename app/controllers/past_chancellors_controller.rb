class PastChancellorsController < ApplicationController
  def index
    @index_page = HistoricAppointmentsIndex.find!(request.path)
    setup_content_item_and_navigation_helpers(@index_page)
  end
end
