class MinistersController < ApplicationController
  before_action :set_locale

  def index
    @ministers = MinistersIndex.find!(request.path)
    setup_content_item_and_navigation_helpers(@ministers)
  end

private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
