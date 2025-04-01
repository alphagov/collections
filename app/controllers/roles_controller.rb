class RolesController < ApplicationController
  around_action :switch_locale

  def show
    ab_test = GovukAbTesting::AbTest.new(
      "GraphQLRoles",
      allowed_variants: %w[A B Z],
      control_variant: "Z",
    )
    @requested_variant = ab_test.requested_variant(request.headers)
    @requested_variant.configure_response(response)

    content_item_data = if params[:graphql] == "false"
                          load_from_content_store
                        elsif params[:graphql] == "true" || @requested_variant.variant?("B")
                          load_from_graphql
                        else
                          load_from_content_store
                        end

    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: { role: RolePresenter.new(content_item_data) }
  end

  def load_from_graphql
    @role = Graphql::Role.find!(request.path)
    @role.content_item
  end

  def load_from_content_store
    @role = Role.find!(request.path)
    @role.content_item.content_item_data
  end
end
