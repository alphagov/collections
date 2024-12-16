class WorldController < ApplicationController
  def index
    if Features.graphql_feature_enabled? || params.include?(:graphql)
      world_index = Graphql::WorldIndex.find!(request.path)
      content_item_data = world_index.content_item
    else
      world_index = WorldIndex.find!(request.path)
      content_item_data = world_index.content_item.content_item_data
    end

    @presented_index = WorldIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(world_index)
  end
end
