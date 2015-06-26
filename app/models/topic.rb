class Topic
  def initialize(content_api_client, topic_slug)
    @content_api_client = content_api_client
    @topic_slug = topic_slug
  end

  def build
    if valid?
      self
    end
  end

  def child_tags
    child_tags_lookup
  end

  def beta?
    topic_content_from_content_store.details.beta
  end

  def description
    details.description
  end

  def title
    content_api_lookup.title
  end

private

  TAG_TYPE = "specialist_sector".freeze

  attr_reader :content_api_client, :topic_slug

  def valid?
    content_api_lookup.present?
  end

  def content_api_lookup
    @_content_api_lookup ||= content_api_client.tag(topic_slug, TAG_TYPE)
  end

  def details
    content_api_lookup.details
  end

  def child_tags_lookup
    content_api_client.child_tags(TAG_TYPE, topic_slug, sort: "alphabetical")
  end

  def topic_content_from_content_store
    @topic_content_from_content_store ||= begin
      ContentItem.find!("/topic/" + topic_slug)
    end
  end
end
