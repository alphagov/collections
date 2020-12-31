class CoronavirusLocalRestrictionsController < ApplicationController
  OUT_OF_DATE_CACHE_TIME = 5.minutes
  MAX_CACHE_TIME = 30.minutes

  def show
    expires_in(cache_time, public: true)
    @content_item = content_item.to_hash

    if params[:postcode].nil?
      render
      return
    end

    @search = PostcodeLocalRestrictionSearch.new(params[:postcode])

    if @search.blank_postcode? || @search.invalid_postcode?
      render
    elsif @search.no_restriction? || @search.no_information?
      render :no_information
    else
      expires_in(restriction_expiry(@search), public: true)

      render :results
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

  def cache_time
    out_of_date? ? OUT_OF_DATE_CACHE_TIME : MAX_CACHE_TIME
  end

  def restriction_expiry(search)
    return cache_time unless search.local_restriction&.future

    future_restriction = search.local_restriction.future
    future_start = Time.zone.parse("#{future_restriction['start_date']} #{future_restriction['start_time']}")
    time_until_restriction = future_start - Time.zone.now

    [time_until_restriction, cache_time].min
  end

  def out_of_date?
    false
  end

  helper_method :out_of_date?
end
