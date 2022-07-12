class BrowseController < ApplicationController
  def index
    page = MainstreamBrowsePage.find("/browse")
    @dimension26 = 1
    @dimension27 = page.top_level_browse_pages.count || 0
    setup_content_item_and_navigation_helpers(page)
    index_html(page)
  end

  def show
    page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(page)
    show_html(page)
  end

private

  def show_html(page)
    template = :new_show
    slimmer_template "gem_layout_full_width"
    render template, locals: { page: page }
  end

  def index_html(page)
    template = :new_index
    slimmer_template "gem_layout_full_width"
    render template, locals: { page: page }
  end
end
