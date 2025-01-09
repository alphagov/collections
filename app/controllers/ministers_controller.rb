class MinistersController < ApplicationController
  around_action :switch_locale

  def index
    content_item_data = if params[:graphql] == "false"
                          load_from_content_store
                        elsif params[:graphql] == "true" || Features.graphql_feature_enabled?
                          load_from_graphql
                        else
                          load_from_content_store
                        end

    @presented_ministers = MinistersIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(@ministers_index)
  end

  def load_from_graphql
    @ministers_index = Graphql::MinistersIndex.find!(request.path)
    @ministers_index.content_item
  end

  def load_from_content_store
    @ministers_index = MinistersIndex.find!(request.path)
    @ministers_index.content_item.content_item_data
  end
end
