class WorldLocationNewsController < ApplicationController
  around_action :switch_locale

  def show
    @world_location_news = WorldLocationNews.find!(request.path)
    setup_content_item_and_navigation_helpers(@world_location_news)
  end
end
