class MinistersController < ApplicationController
  around_action :switch_locale

  def index
    @ministers = MinistersIndex.find!(request.path)
    setup_content_item_and_navigation_helpers(@ministers)
  end
end
