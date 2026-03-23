class RolesController < ApplicationController
  include PrometheusSupport

  around_action :switch_locale

  def show
    @role = Role.find_content_item!(request)

    content_item_data = @role.content_item

    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: { role: RolePresenter.new(content_item_data) }
  end
end
