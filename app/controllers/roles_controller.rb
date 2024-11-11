class RolesController < ApplicationController
  around_action :switch_locale

  def show
    @role = Role.find!(request.path)
    setup_content_item_and_navigation_helpers(@role)
    content_item_data = @role.content_item.content_item_data
    render :show, locals: { role: RolePresenter.new(content_item_data) }
  end
end
