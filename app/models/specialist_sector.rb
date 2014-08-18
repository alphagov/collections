class SpecialistSector

  def initialize(content_api_client, sector_tag)
    @content_api_client = content_api_client
    @sector_tag = sector_tag
  end

  def build
    if valid?
      self
    end
  end

  def child_tags
    child_tags_lookup
  end

  def description
    details.description
  end

  def title
    content_api_lookup.title
  end

private

  TAG_TYPE = "specialist_sector".freeze

  attr_reader :content_api_client, :sector_tag

  def valid?
    content_api_lookup.present?
  end

  def content_api_lookup
    @_api_response ||= content_api_client.tag(sector_tag, TAG_TYPE)
  end

  def details
    content_api_lookup.details
  end

  def child_tags_lookup
    content_api_client.child_tags(TAG_TYPE, sector_tag, sort: "alphabetical")
  end
end
