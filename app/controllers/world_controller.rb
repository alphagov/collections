class WorldController < ApplicationController
  include PrometheusSupport

  GRAPHQL_TRAFFIC_RATE = Rails.application.config.graphql_traffic_rates.fetch("world_index", 0)
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
    set_prometheus_labels("graphql_status_code" => 200, "graphql_api_timeout" => false)
    @world_index = WorldIndex.find_from_graphql!(request.path)
    @world_index.content_item.content_item_data
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
