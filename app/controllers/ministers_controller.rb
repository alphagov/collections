class MinistersController < ApplicationController
  include PrometheusSupport

  around_action :switch_locale

  def index
    @ministers_index = MinistersIndex.find!(request)

    content_item_data = @ministers_index.content_item.content_item_data

    @presented_ministers = MinistersIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(@ministers_index)
  end
end
