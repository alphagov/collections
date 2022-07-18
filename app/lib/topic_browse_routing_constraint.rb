class TopicBrowseRoutingConstraint
  include TopicBrowseHelper

  def matches?(request)
    @path = request.path
    topic_browse_mapping(@path).present?
  end
end
