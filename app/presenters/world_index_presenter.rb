class WorldIndexPresenter
  def initialize(world_index)
    @world_index = world_index
  end

  def title
    @world_index.content_item.title
  end
end
