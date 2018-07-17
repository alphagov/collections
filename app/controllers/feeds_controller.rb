class FeedsController < ApplicationController
  enable_request_formats organisation: :atom

  before_action do
    # Allows ajax requests as per https://govuk.zendesk.com/agent/tickets/1935680
    if request.format.atom?
      response.headers["Access-Control-Allow-Origin"] = "*"
    end
  end

  def organisation
    path = "/government/organisations/#{organisation_name}#{locale}"
    @organisation = Organisation.find!(path)

    results = FeedContent.new(filter_organisations: organisation_name).results
    @items = results.map { |result| FeedEntryPresenter.new(result) }
  end

private

  def organisation_name
    params[:organisation_name]
  end

  def locale
    ".#{params[:locale]}" if params[:locale]
  end
end
