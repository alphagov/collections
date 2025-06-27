class RolesController < ApplicationController
  include PrometheusSupport

  around_action :switch_locale

  GRAPHQL_TRAFFIC_RATE = 0.02207862 # This is a decimal version of a percentage, so can be between 0 and 1

  def show
    content_item_data = if params[:graphql] == "false"
                          load_from_content_store
                        elsif params[:graphql] == "true" || graphql_ab_test?(GRAPHQL_TRAFFIC_RATE)
                          load_from_graphql
                        else
                          load_from_content_store
                        end

    setup_content_item_and_navigation_helpers(@role)
    render :show, locals: { role: RolePresenter.new(content_item_data) }
  end

  def load_from_graphql
    @role = Graphql::Role.find!(request.path)
    if @role.content_item.nil?
      set_prometheus_labels("graphql_contains_errors" => true)
      load_from_content_store
    else
      @role.content_item
    end
  rescue GdsApi::HTTPErrorResponse => e
    set_prometheus_labels("graphql_status_code" => e.code)
    load_from_content_store
  rescue GdsApi::TimedOutException
    set_prometheus_labels("graphql_api_timeout" => true)
    load_from_content_store
  end

  def load_from_content_store
    @role = Role.find!(request.path)
    @role.content_item.content_item_data
  end
end
