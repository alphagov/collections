class ListSet
  include Enumerable

  FORMATS_TO_EXCLUDE = %w(
    fatality_notice
    government_response
    news_story
    press_release
    speech
    statement
    world_location_news_article
  ).to_set

  def initialize(tag_type, tag_slug, group_data)
    @tag_type = tag_type
    @tag_slug = tag_slug
    @group_data = group_data || []
  end

  def each
    lists.each do |l|
      yield l
    end
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
      content_tagged_to_topic.reject do |content|
        ListSet::FORMATS_TO_EXCLUDE.include? content.format
      end.sort_by(&:title)
    )]
  end

  def curated_list
    @group_data.map do |group|
      contents = group["contents"].map do |api_url_or_base_path|
        base_path = URI.parse(api_url_or_base_path).path.chomp('.json')
        content_tagged_to_topic.find do |content|
          content.base_path == base_path
        end
      end.compact

      ListSet::List.new(group["name"], contents) if contents.any?
    end.compact
  end

  def content_tagged_to_topic
    Topic::ContentTaggedToTopic.new(@tag_type, @tag_slug)
  end
end
