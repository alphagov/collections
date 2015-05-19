class TopicsController < ApplicationController
  before_filter { validate_slug_param(:sector) }

  def show
    @topic = Topic.new(content_api, sector_tag).build

    return error_404 unless @topic.present?

    set_slimmer_headers(format: "specialist-sector")
  end

private

  def content_api
    Collections.services(:content_api)
  end

  def sector_tag
    params[:sector]
  end
end
