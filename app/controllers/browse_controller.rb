class BrowseController < ApplicationController
  def index
    page = MainstreamBrowsePage.find("/browse")
    @dimension26 = 1
    @dimension27 = page.top_level_browse_pages.count || 0
    template = :index
    setup_content_item_and_navigation_helpers(page)
    slimmer_template "gem_layout_full_width"
    render template, locals: { page: page }
  end

  def show
    page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    template = :show
    setup_content_item_and_navigation_helpers(page)
    slimmer_template "gem_layout_full_width"
    render template, locals: { page: page }
  end
end
