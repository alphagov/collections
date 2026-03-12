class MinistersController < ApplicationController
  include PrometheusSupport

  around_action :switch_locale

  # GRAPHQL_TRAFFIC_RATE = Rails.application.config.graphql_traffic_rates.fetch("ministers_index", 0)

  def index
    @ministers_index = MinistersIndex.find_content_item!(request)

    content_item_data = @ministers_index.content_item

    @presented_ministers = MinistersIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(@ministers_index)
  end
end
