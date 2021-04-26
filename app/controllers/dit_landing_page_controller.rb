class DitLandingPageController < ApplicationController
  around_action :switch_locale
  slimmer_template :gem_layout_full_width

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
