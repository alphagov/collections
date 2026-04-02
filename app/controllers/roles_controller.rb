class RolesController < ApplicationController
  include PrometheusSupport

  around_action :switch_locale

  def show
    @role = Role.find!(request)

    content_item_data = @role.content_item.content_item_data

    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: { role: RolePresenter.new(content_item_data) }
  end
end
