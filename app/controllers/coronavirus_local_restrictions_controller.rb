class CoronavirusLocalRestrictionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:legacy]

  def show
    @content_item = content_item.to_hash

    if params[:postcode].nil?
      render
      return
    end

    @search = CoronavirusRestrictionSearch.new(params[:postcode])

    if @search.blank_postcode? || @search.invalid_postcode?
      render
    elsif !@search.result
      render :no_information
    else
      render :results, locals: { result: @search.result }
    end
  end

  # This action is temporary. It exists to prevent errors while the application
  # transitions from a POST endpoint to a GET one.
  def legacy
    redirect_to find_coronavirus_local_restrictions_path(postcode: params["postcode-lookup"])
  end

private

  def content_item
    base_path = request.path
    @content_item ||= begin
      Rails.cache.fetch("collections_content_items#{base_path}", expires_in: 10.minutes) do
        ContentItem.find!(base_path)
      end
    end
  end
end
