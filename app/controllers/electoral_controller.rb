class ElectoralController < ApplicationController

  def show
    @content_item = { title: "Elections" }

    if params[:postcode].nil?
      render
      return
    end

    @postcode = params[:postcode].strip
    postcode_result = JSON.parse(RestClient.get("https://wheredoivote.co.uk/api/beta/postcode/#{CGI.escape(@postcode)}.json").body).to_h

    @council = postcode_result["council"]

    render :results
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
