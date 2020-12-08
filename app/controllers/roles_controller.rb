class RolesController < ApplicationController
  around_action :switch_locale

  def show
    @role = Role.find!(request.path)
    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: { role: @role }
  end
end
