class BrowseController < ApplicationController
  def index
    @full_width = true
    page = MainstreamBrowsePage.find("/browse")
    setup_content_item_and_navigation_helpers(page)
    render :index, locals: { page: }
  end

  def show
    @full_width = true
    page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(page)

    show_html(page)
  end

private

  def show_html(page)
    template = :show
    render template, locals: { page: }
  end
end
