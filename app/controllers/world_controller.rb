class WorldController < ApplicationController
  def index
    if Features.graphql_feature_enabled?
      index = WorldIndexGraphql.find!("/world")
      @presented_index = WorldIndexGraphqlPresenter.new(index)
    else
      index = WorldIndex.find!("/world")
      @presented_index = WorldIndexPresenter.new(index)
    end

    setup_content_item_and_navigation_helpers(index)
  end
end
