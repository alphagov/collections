class SubSection
  attr_reader :sub_section_slug

  delegate :title, to: :tag_from_content_api

  def initialize(sub_section_slug)
    @sub_section_slug = sub_section_slug
  end

  def lists
    if curated_links?
      @lists ||= curated_lists
    else
      @lists ||= fallback_list_of_uncurated_links
    end
  end

  def curated_links?
    groups.any?
  end

  def exists?
    tag_from_content_api.present?
  end

private

  def groups
    (subsection_from_content_store.details && subsection_from_content_store.details.groups) || []
  end

  def curated_lists
    groups.map do |group|
      links = group.contents.map do |url|
        tagged_items_from_content_api.find { |artefact| artefact.id == url }
      end

      # It's possible that the content store still contains links to items
      # that have been removed from the content api, or that the item item
      # is no longer tagged to this topic.
      links.compact!

      OpenStruct.new(name: group.name, links: links)
    end
  end

  def fallback_list_of_uncurated_links
    [OpenStruct.new(
      name: 'A&#8202;to&#8202;Z', # &#8202 = hairspace
      links: tagged_items_from_content_api
    )]
  end

  # Returns an array containing OpenStructs with keys :title, :web_url.
  def tagged_items_from_content_api
    @tagged_items_from_content_api ||= begin
      content_api.with_tag(sub_section_slug).results.sort_by(&:title)
    end
  end

  # Returns an OpenStruct with the content blob.
  def subsection_from_content_store
    @subsection_from_content_store ||= begin
      content_store = Collections.services(:content_store)
      content_store.content_item('/browse/' + sub_section_slug)
    end
  end

  def tag_from_content_api
    @tag_from_content_api ||= content_api.tag(sub_section_slug)
  end

  def content_api
    Collections.services(:content_api)
  end
end
