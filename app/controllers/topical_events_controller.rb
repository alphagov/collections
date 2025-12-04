class TopicalEventsController < ApplicationController
  include PrometheusSupport

  enable_request_formats show: :atom

  GRAPHQL_TRAFFIC_RATE = 0.01 # This is a decimal version of a percentage, so can be between 0 and 1

  def show
    if params[:graphql] == "false"
      load_from_content_store
    elsif params[:graphql] == "true" || graphql_ab_test?(GRAPHQL_TRAFFIC_RATE)
      load_from_graphql
    else
      load_from_content_store
    end

    respond_to do |format|
      format.html do
        setup_content_item_and_navigation_helpers(@topical_event)
      end

      format.atom do
        results = FeedContent.new(filter_topical_events: params[:name]).results(10)
        items = results.map { |result| FeedEntryPresenter.new(result) }

        render "feeds/feed", locals: { items:, root_url: Plek.new.website_root + path, title: "#{@topical_event.title} - Activity on GOV.UK" }
      end
    end
  end

  def array_of_links_to_organisations(organisations)
    organisations.map do |organisation|
      helpers.link_to organisation[:title], organisation[:base_path], class: "organisation-link govuk-link"
    end
  end

  helper_method :array_of_links_to_organisations

private

  def path
    @path ||= topical_event_path(params[:name])
  end

  def load_from_graphql
    set_prometheus_labels("graphql_status_code" => 200, "graphql_api_timeout" => false)
    @topical_event = TopicalEvent.find_from_graphql!(path)
  rescue GdsApi::HTTPErrorResponse => e
    set_prometheus_labels("graphql_status_code" => e.code)
    load_from_content_store
  rescue GdsApi::TimedOutException
    set_prometheus_labels("graphql_api_timeout" => true)
    load_from_content_store
  end

  def load_from_content_store
    @topical_event = TopicalEvent.find!(path)
  end
end
