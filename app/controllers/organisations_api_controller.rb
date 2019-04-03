class OrganisationsApiController < ApplicationController
  enable_request_formats index: :json, show: :json

  def index
    presented_organisations = presented_organisations(start: start_index)
    set_link_header(links: presented_organisations[:_response_info][:links])
    respond_to do |f|
      f.json do
        render json: presented_organisations
      end
    end
  end

  def show
    presented_organisation = presented_organisation(slug: params[:organisation_name])
    set_link_header(links: presented_organisation[:_response_info][:links])
    respond_to do |f|
      f.json do
        render json: presented_organisation
      end
    end
  rescue OrganisationNotFound
    error_404
  end

private

  RESULTS_PER_PAGE = 20

  def presented_organisations(start:)
    organisations = organisations_from_search(count: RESULTS_PER_PAGE, start: start)
    OrganisationsApiPresenter.new(
      organisations["results"],
      current_page: current_page,
      results_per_page: RESULTS_PER_PAGE,
      total_results: organisations["total"],
      current_url_without_parameters: current_url_without_parameters
    ).present
  end

  def presented_organisation(slug:)
    organisation = organisation_from_search(slug: slug)

    raise OrganisationNotFound if organisation["total"].zero?

    OrganisationsApiPresenter.new(
      organisation["results"],
      current_page: 1,
      results_per_page: 1,
      total_results: 1,
      current_url_without_parameters: current_url_without_parameters,
      wrap_in_results_array: false
    ).present
  end

  def organisations_from_search(count:, start:)
    cache_key = "api/organisations/#{count}/#{start}"

    @organisations_from_search ||= Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      Services.rummager.search(
        filter_format: "organisation",
        order: "title",
        count: count,
        start: start
      )
    end
  end

  def organisation_from_search(slug:)
    cache_key = "api/organisation/#{slug}"

    @organisation_from_search ||= Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      Services.rummager.search(
        filter_format: "organisation",
        filter_slug: slug,
        count: 1,
        start: 0
      )
    end
  end

  def set_link_header(links:)
    response.headers["Link"] = LinkHeaderPresenter.new(links).present
  end

  def start_index
    (current_page - 1) * RESULTS_PER_PAGE
  end

  def current_page
    return page_param if page_param.positive?

    1
  end

  def page_param
    params[:page].to_i
  end

  def current_url_without_parameters
    request.base_url + request.path
  end

  class OrganisationNotFound < StandardError; end
end
