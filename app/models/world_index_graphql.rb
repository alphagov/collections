class WorldIndexGraphql
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    query = Graphql::WorldIndexQuery.new(base_path).query

    edition = Services.publishing_api.graphql_query(query).dig("data", "edition")
    new(edition)
  end
end
