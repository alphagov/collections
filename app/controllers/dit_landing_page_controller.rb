class DitLandingPageController < ApplicationController
  around_action :switch_locale

  def show
    @presenter = presenter
  end

private

  def content_item
    ContentItem.find!(request.path)
  end

  def presenter
    DitLandingPagePresenter.new(content_item)
  end
end
