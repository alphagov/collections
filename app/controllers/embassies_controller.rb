class EmbassiesController < ApplicationController
  def index
    embassies_index = EmbassiesIndex.find!("/world/embassies")
    @presented_embassies = EmbassiesIndexPresenter.new(embassies_index)
    setup_content_item_and_navigation_helpers(embassies_index)
  end
end
