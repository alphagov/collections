class RolesController < ApplicationController
  around_action :switch_locale

  def show
    @role = Role.find!(request.path)

    content_item_data = @role.content_item.content_item_data

    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: { role: RolePresenter.new(content_item_data) }
  end
end
