class CoronavirusLandingPageController < ApplicationController
  before_action :set_locale

  def show
    @content_item = ContentItem.find!("/government/topical-events/coronavirus-covid-19-uk-government-response").to_hash
    render :show
  end

private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
