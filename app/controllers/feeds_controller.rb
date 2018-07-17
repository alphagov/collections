class FeedsController < ApplicationController
  enable_request_formats organisation: :atom

  def organisation
    set_access_control_allow_origin_header if request.format.atom?

    path = "/government/organisations/#{organisation_name}#{locale}"
    @organisation = Organisation.find!(path)

    results = Feeds::FeedContent.new(filter_organisations: organisation_name).results
    @items = results.map { |result| Feeds::OrganisationFeedEntryPresenter.new(result) }
  end

private

  # allows ajax requests as per https://govuk.zendesk.com/agent/tickets/1935680
  def set_access_control_allow_origin_header
    response.headers["Access-Control-Allow-Origin"] = "*"
  end

  def organisation_name
    params[:organisation_name]
  end

  def locale
    ".#{params[:locale]}" if params[:locale]
  end
end
