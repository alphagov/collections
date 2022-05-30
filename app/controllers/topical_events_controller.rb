class TopicalEventsController < ApplicationController
  def show
    @topical_event = TopicalEvent.find!(request.path)
    setup_content_item_and_navigation_helpers(@topical_event)
  end
end
