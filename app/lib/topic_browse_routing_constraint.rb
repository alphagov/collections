class TopicBrowseRoutingConstraint
  def initialize
    @path = "benefits-credits/tax-credits"
  end

  def matches?(request)
    topic = request.params[:topic_topic_slug]
    subtopic = request.params[:subtopic_slug]
    @path == "#{topic}/#{subtopic}"
  end

end
