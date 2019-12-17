class RolesController < ApplicationController
  before_action :set_locale

  def show
    @role = Role.find!(request.path)
    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: { role: @role }
  end

private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
