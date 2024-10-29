class WorldIndex
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    query = "fragment worldLocationInfo on WorldLocation {
      active
      name
      slug
    }

    {
      edition(basePath: \"#{base_path}\") {
        ... on WorldIndex {
          title

          worldLocations {
            ...worldLocationInfo
          }

          internationalDelegations {
            ...worldLocationInfo
          }
        }
      }
    }"

    content_item = Services.publishing_api.get_grapqhl_data(query)
    content_item_hash = content_item.to_h.dig("data", "edition")
    new(content_item_hash)
  end
end
