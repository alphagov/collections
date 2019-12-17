class PeopleController < ApplicationController
  before_action :set_locale

  def show
    @person = Person.find!(request.path)
    setup_content_item_and_navigation_helpers(@person)
    render :show, locals: { person: @person }
  end

private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
