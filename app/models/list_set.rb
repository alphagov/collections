class ListSet
  include Enumerable
  delegate :each, to: :lists

  BROWSE_FORMATS_TO_EXCLUDE = %w[
    fatality_notice
    news_article
    speech
    world_location_news_article
    travel-advice
  ].to_set

  TOPIC_FORMATS_TO_EXCLUDE = %w[
    fatality_notice
    news_article
    speech
    world_location_news_article
  ].to_set

  def initialize(tag_type, tag_content_id, group_data = nil)
    @tag_type = tag_type
    @tag_content_id = tag_content_id
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
      content_tagged_to_tag
        .reject { |content| excluded_formats.include? content.format }
        .sort_by(&:title),
    )]
  end

  def curated_list
    curated_data = @group_data.map do |group|
      contents = group["contents"].map do |base_path|
        content_tagged_to_tag.find { |content| content.base_path == base_path }
      end

      ListSet::List.new(group["name"], contents.compact) if contents.any?
    end

    curated_data.compact
  end

  def content_tagged_to_tag
    @content_tagged_to_tag ||= SearchApiSearch.new(
      :start => 0,
      :count => SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      filter_name => [@tag_content_id],
      :fields => %w[title link format],
    )
  end

  def filter_name
    if @tag_type == "section"
      # :filter_mainstream_browse_page_content_ids
      :filter_topic_content_ids
    else
      :filter_topic_content_ids
    end
  end

  def excluded_formats
    if @tag_type == "section"
      BROWSE_FORMATS_TO_EXCLUDE
    else
      TOPIC_FORMATS_TO_EXCLUDE
    end
  end
end
