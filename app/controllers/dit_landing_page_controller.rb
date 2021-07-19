class DitLandingPageController < ApplicationController
  around_action :switch_locale

  def show
    @presenter = presenter
  end

private

  def set_slimmer_template
    set_gem_layout_full_width
  end

  def content_item
    ContentItem.find!(request.path)
  end

  def presenter
    DitLandingPagePresenter.new(content_item)
  end
end
