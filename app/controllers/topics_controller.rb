class TopicsController < ApplicationController
  before_filter { validate_slug_param(:topic_slug) }

  rescue_from GdsApi::HTTPNotFound, :with => :error_404

  def topic
    @topic = Topic.find(request.path)

    set_slimmer_headers(format: "specialist-sector")
  end
end
