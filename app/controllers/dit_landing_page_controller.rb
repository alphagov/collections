class DitLandingPageController < ApplicationController
  around_action :switch_locale

  def show
    @lang = params[:locale] || "en"
    @translation_links = [
      { locale: "en", base_path: "/eutraders", text: "English", active: @lang == "en" },
      { locale: "cy", base_path: "/eutraders.cy", text: "Cymraeg", active: @lang == "cy" },
    ]
  end

private

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
