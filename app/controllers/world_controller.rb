class WorldController < ApplicationController
  def index
    ab_test = GovukAbTesting::AbTest.new(
      "GraphQLWorldIndex",
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

    @presented_index = WorldIndexPresenter.new(content_item_data)
    setup_content_item_and_navigation_helpers(@world_index)
  end

  def load_from_graphql
    @world_index = Graphql::WorldIndex.find!(request.path)
    @world_index.content_item
  end

  def load_from_content_store
    @world_index = WorldIndex.find!(request.path)
    @world_index.content_item.content_item_data
  end
end
