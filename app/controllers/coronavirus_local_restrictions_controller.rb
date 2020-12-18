class CoronavirusLocalRestrictionsController < ApplicationController
  MAX_CACHE_TIME = 30.minutes

  def show
    expires_in(MAX_CACHE_TIME, public: true)
    @content_item = content_item.to_hash

    if params[:postcode].nil?
      render
      return
    end

    @search = CoronavirusRestrictionSearch.new(params[:postcode])

    if @search.blank_postcode? || @search.invalid_postcode?
      render
    elsif @search.devolved_nation_result
      @result = @search.devolved_nation_result

      render :devolved_nation_result
    elsif @search.england_result
      @result = @search.england_result

      expires_in(restriction_expiry(@result), public: true)
      render :england_result
    else
      render :no_information
    end
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

  def restriction_expiry(england_result)
    return MAX_CACHE_TIME unless england_result.future_restriction

    time_until_restriction = england_result.future_restriction.start_time - Time.zone.now
    [time_until_restriction, MAX_CACHE_TIME].min
  end
end
