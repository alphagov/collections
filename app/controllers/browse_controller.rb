class BrowseController < ApplicationController
  include ResearchPanelBannerHelper

  slimmer_template "gem_layout_full_width"

  def index
    page = MainstreamBrowsePage.find("/browse")
    @dimension26 = 1
    @dimension27 = page.top_level_browse_pages.count || 0
    setup_content_item_and_navigation_helpers(page)
    render :index, locals: { page: page }
  end

  def show
    @sign_up_url = signup_url_for(request.path)
    page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(page)

    show_html(page)
  end

private

  def show_html(page)
    template = :show
    render template, locals: { page: page }
  end
end
