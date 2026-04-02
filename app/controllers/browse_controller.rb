class BrowseController < ApplicationController
  def index
    @full_width = true
    page = MainstreamBrowsePage.find(request)
    setup_content_item_and_navigation_helpers(page)
    render :index, locals: { page: }
  end

  def show
    @full_width = true
    base_path = "/browse/#{params[:top_level_slug]}"
    request.path_info = base_path
    page = MainstreamBrowsePage.find(request)
    setup_content_item_and_navigation_helpers(page)

    show_html(page)
  end

private

  def show_html(page)
    template = :show
    render template, locals: { page: }
  end
end
