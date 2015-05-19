class TopicPresenter
  attr_reader :artefact, :topic

  delegate :web_url, to: :artefact

  def self.build_from_subtopic_content(content, parent_topic)
    content.map { |artefact| new(artefact, parent_topic) }
  end

  def initialize(artefact, topic)
    @artefact = artefact
    @topic = topic
  end

  # This strips away the initial part of an item title if it contains the
  # title of the current topic to remove any duplication. The
  # leading character of the remainder of the title is then upcased.
  #
  # eg. "Oil and gas: wells" -> "Wells"
  #
  def title
    pattern = /\A#{Regexp.escape(topic.title)}: /

    if artefact.title =~ pattern
      title = artefact.title.sub(pattern, '')
      title[0] = title[0].upcase
      title
    else
      artefact.title
    end
  end
end
