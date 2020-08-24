class DitLandingPageController < ApplicationController
  around_action :switch_locale

  def show
    @lang = params[:locale] || "en"
  end

private

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
