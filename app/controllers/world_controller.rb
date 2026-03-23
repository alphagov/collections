class WorldController < ApplicationController
  include PrometheusSupport

  def index
    @world_index = WorldIndex.find_content_item!(request)

    content_item_data = @world_index.content_item

    @presented_index = WorldIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(@world_index)
  end
end
