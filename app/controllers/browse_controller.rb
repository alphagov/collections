class BrowseController < ApplicationController
  def index
    @page = MainstreamBrowsePage.find("/browse")
    setup_content_item_and_navigation_helpers(@page)
  end
end
