class MinistersController < ApplicationController
  around_action :switch_locale

  def index
    if params.include?(:graphql)
      ministers_index = Graphql::MinistersIndex.find!(request.path)
      content_item_data = ministers_index.content_item
    else
      ministers_index = MinistersIndex.find!(request.path)
      content_item_data = ministers_index.content_item.content_item_data
    end

    @presented_ministers = MinistersIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(ministers_index)
  end
end
