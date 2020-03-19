class CoronavirusLandingPageController < ApplicationController
  before_action :set_locale

  def show
    @content_item = { "locale" => "en" }
    breadcrumbs = [{ title: "Home", url: "/", is_page_parent: true }]

    render "show", locals: { breadcrumbs: breadcrumbs }
  end

private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
