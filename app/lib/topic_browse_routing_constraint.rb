class TopicBrowseRoutingConstraint
  include TopicBrowseHelper

  def matches?(request)
    topic_as_browse_mapping(request).present?
  end
end
