class BrowseController < ApplicationController
  include NewBrowseAbTestable
  slimmer_template "gem_layout_full_width"

  def index
    page = MainstreamBrowsePage.find("/browse")
    @dimension26 = 1
    @dimension27 = page.top_level_browse_pages.count || 0
    setup_content_item_and_navigation_helpers(page)
    render :index, locals: { page: }
  end

  def show
    set_new_browse_response_header if new_browse_page_under_test?

    page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(page)

    show_html(page)
  end

private

  helper_method :new_browse_variant_b?

  def show_html(page)
    template = :show
    render template, locals: { page: }
  end
end
