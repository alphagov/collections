class ListSet
  include Enumerable
  delegate :each, to: :lists

  BROWSE_FORMATS_TO_EXCLUDE = %w(
    fatality_notice
    news_article
    speech
    world_location_news_article
    travel-advice
  ).to_set

  TOPIC_FORMATS_TO_EXCLUDE = %w(
    fatality_notice
    news_article
    speech
    world_location_news_article
  ).to_set

  def initialize(tag_type, tag_slug, group_data = nil)
    @tag_type = tag_type
    @tag_slug = tag_slug
    @group_data = group_data || []
  end

  def curated?
    @group_data.any?
  end

  private

  def lists
    if @group_data.any?
      curated_list
    else
      a_to_z_list
    end
  end

  def a_to_z_list
    [ListSet::List.new(
      "A to Z",
      content_tagged_to_tag.reject do |content|
        excluded_formats.include? content.format
      end.sort_by(&:title)
    )]
  end

  def curated_list
    @group_data.map do |group|
      contents = group["contents"].map do |base_path|
        content_tagged_to_tag.find do |content|
          content.base_path == base_path
        end
      end.compact

      ListSet::List.new(group["name"], contents) if contents.any?
    end.compact
  end

  def content_tagged_to_tag
    @content_tagged_to_tag ||= RummagerSearch.new({
      :start => 0,
      :count => RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      filter_name => [@tag_slug],
      :fields => %w(title link format),
    })
  end

  def filter_name
    if @tag_type == 'section'
      :filter_mainstream_browse_pages
    else
      :filter_specialist_sectors
    end
  end

  def excluded_formats
    if @tag_type == 'section'
      BROWSE_FORMATS_TO_EXCLUDE
    else
      TOPIC_FORMATS_TO_EXCLUDE
    end
  end
end
