
class ListSet

  FORMATS_TO_EXCLUDE = %w(
    fatality_notice
    government_response
    news_story
    press_release
    speech
    statement
    world_location_news_article
  ).to_set

  ListItem = Struct.new(:title, :base_path)

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
  include Enumerable

  def curated?
    @group_data.any?
  end

  private

  def lists
    @_lists ||= build_lists
  end

  def build_lists
    if curated?
      build_curated_lists
    else
      build_a_to_z_list
    end
  end

  def build_curated_lists
    @group_data.each_with_object([]) do |group, results|
      contents = group["contents"].each_with_object([]) do |api_url, results|
        if item = find_content_item(api_url)
          results << ListItem.new(
            item["title"],
            URI.parse(item["web_url"]).path,
          )
        end
      end
      results << ListSet::List.new(group["name"], contents) if contents.any?
    end
  end

  def build_a_to_z_list
    [
      ListSet::List.new(
        'A to Z',
        filtered_content_tagged_to_topic.map do |item|
          ListItem.new(
            item["title"],
            URI.parse(item["web_url"]).path,
          )
        end.sort_by(&:title)
      )
    ]
  end

  def find_content_item(api_url)
    api_path = URI.parse(api_url).path
    content_tagged_to_topic.find do |content|
      URI.parse(content["id"]).path == api_path
    end
  end

  def filtered_content_tagged_to_topic
    content_tagged_to_topic.select do |item|
      ! FORMATS_TO_EXCLUDE.include?(item["format"])
    end
  end

  def content_tagged_to_topic
    @_content_tagged_to_topic ||= Collections.services(:content_api).with_tag(@tag_slug, @tag_type)["results"]
  end
end
