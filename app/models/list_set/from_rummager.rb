class ListSet::FromRummager
  include Enumerable

  def initialize(slug, groups)
    @slug = slug
    @groups = groups || []
  end

  def each
    lists.each do |l|
      yield l
    end
  end

  private

  def lists
    if @groups.any?
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
    @groups.map do |group|
      contents = group["contents"].map do |api_url|
        content_tagged_to_topic.find do |content|
          content.base_path + ".json" == URI.parse(api_url).path
        end
      end.compact

      ListSet::List.new(group["name"], contents) if contents.any?
    end.compact
  end

  def content_tagged_to_topic
    Topic::ContentTaggedToTopic.new(@slug)
  end
end
