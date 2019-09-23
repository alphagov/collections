class RolesController < ApplicationController
  def show
    # Only ministerial roles have base paths, other role types aren't rendered
    @role = Role.find!("/government/ministers/#{params[:role_name]}")
    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: {
        role: @role,
    }
  end
end
