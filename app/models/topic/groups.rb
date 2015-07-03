
class Topic::Groups

  FORMATS_TO_EXCLUDE = %w(
    fatality_notice
    government_response
    news_story
    press_release
    speech
    statement
    world_location_news_article
  ).to_set

  List = Struct.new(:title, :contents)
  ListItem = Struct.new(:title, :base_path)

  def initialize(subtopic_slug, group_data)
    @subtopic_slug = subtopic_slug
    @group_data = group_data || []
  end

  def each
    groups.each do |g|
      yield g
    end
  end
  include Enumerable

  private

  def groups
    @_groups ||= build_groups
  end

  def build_groups
    if @group_data.any?
      build_curated_groups
    else
      build_a_to_z_group
    end
  end

  def build_curated_groups
    @group_data.each_with_object([]) do |group, results|
      contents = group["contents"].each_with_object([]) do |api_url, results|
        if item = find_content_item(api_url)
          results << ListItem.new(
            item["title"],
            URI.parse(item["web_url"]).path,
          )
        end
      end
      results << List.new(group["name"], contents) if contents.any?
    end
  end

  def build_a_to_z_group
    [
      List.new(
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
    @_content_tagged_to_topic ||= Collections.services(:content_api).with_tag(@subtopic_slug, "specialist_sector")["results"]
  end
end
