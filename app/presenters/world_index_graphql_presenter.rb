class WorldIndexGraphqlPresenter < WorldIndexPresenter
  def title
    @world_index.content_item["title"]
  end

  def international_delegations
    @world_index.content_item["internationalDelegations"]
  end

private

  def world_locations
    @world_index.content_item["worldLocations"]
  end
end
