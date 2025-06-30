class WorldController < ApplicationController
  include PrometheusSupport

  GRAPHQL_TRAFFIC_RATE = 0.07404692 # This is a decimal version of a percentage, so can be between 0 and 1
  def index
    content_item_data = if params[:graphql] == "false"
                          load_from_content_store
                        elsif params[:graphql] == "true" || graphql_ab_test?(GRAPHQL_TRAFFIC_RATE)
                          load_from_graphql
                        else
                          load_from_content_store
                        end

    @presented_index = WorldIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(@world_index)
  end

  def load_from_graphql
    set_prometheus_labels("graphql_status_code" => 200, "graphql_contains_errors" => false, "graphql_api_timeout" => false)
    @world_index = Graphql::WorldIndex.find!(request.path)
    if @world_index.content_item.nil?
      set_prometheus_labels("graphql_contains_errors" => true)
      load_from_content_store
    else
      @world_index.content_item
    end
  rescue GdsApi::HTTPErrorResponse => e
    set_prometheus_labels("graphql_status_code" => e.code)
    load_from_content_store
  rescue GdsApi::TimedOutException
    set_prometheus_labels("graphql_api_timeout" => true)
    load_from_content_store
  end

  def load_from_content_store
    @world_index = WorldIndex.find!(request.path)
    @world_index.content_item.content_item_data
  end
end
