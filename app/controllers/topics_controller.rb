class TopicsController < ApplicationController
  before_filter { validate_slug_param(:topic_slug) }

  def show
    @topic = Topic.new(content_api, topic_slug).build

    return error_404 unless @topic.present?

    set_slimmer_headers(format: "specialist-sector")
  end

private

  def content_api
    Collections.services(:content_api)
  end

  def topic_slug
    params[:topic_slug]
  end
end
