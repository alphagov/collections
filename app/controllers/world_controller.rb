class WorldController < ApplicationController
  def index
    index = WorldIndex.find!("/world")
    @presented_index = WorldIndexPresenter.new(index)
    setup_content_item_and_navigation_helpers(index)
  end
end
