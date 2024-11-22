class MinistersController < ApplicationController
  around_action :switch_locale

  def index
    ministers_index = MinistersIndex.find!(request.path)
    @presented_ministers = MinistersIndexPresenter.new(ministers_index.content_item.content_item_data)
    setup_content_item_and_navigation_helpers(ministers_index)
  end
end
