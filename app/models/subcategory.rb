class Subcategory
  def initialize(content_api_client, tag_id)
    @content_api_client = content_api_client
    @tag_id = tag_id
  end

  def build
    if valid?
      self
    end
  end

  def description
    details.description
  end

  def parent
    content_api_lookup.parent
  end

  def parent_sector_title
    parent.title
  end

  def related_content
    related_content_lookup
  end

  def title
    content_api_lookup.title
  end

private

  TAG_TYPE = "specialist_sector".freeze

  attr_reader :content_api_client, :tag_id

  def valid?
    content_api_lookup.present?
  end

  def content_api_lookup
    @_api_response ||= content_api_client.tag(tag_id, TAG_TYPE)
  end

  def details
    content_api_lookup.details
  end

  def related_content_lookup
    content_api_client.with_tag(tag_id, TAG_TYPE)
  end
end
