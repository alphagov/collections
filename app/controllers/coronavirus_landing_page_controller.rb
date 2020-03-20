class CoronavirusLandingPageController < ApplicationController
  skip_before_action :set_expiry
  before_action -> { set_expiry(1.minute) }
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
