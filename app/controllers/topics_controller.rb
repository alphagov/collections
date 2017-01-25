class TopicsController < ApplicationController
  def index
    @topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(@topic)
  end

  def show
    @topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(@topic)
  end
end
