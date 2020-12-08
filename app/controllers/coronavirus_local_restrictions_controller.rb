class CoronavirusLocalRestrictionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:results]

  def show
    @content_item = content_item.to_hash

    if params[:postcode].nil?
      render
      return
    end

    @search = PostcodeLocalRestrictionSearch.new(params[:postcode])

    if @search.empty? || @search.invalid?
      render
    elsif @search.no_information?
      render :no_information
    else
      render :results
    end
  end

  def results
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
