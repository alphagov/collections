class BrowseController < ApplicationController
  enable_request_formats top_level_browse_page: [:json]
  enable_request_formats second_level_browse_page: [:json]

  def index
    @page = MainstreamBrowsePage.find("/browse")
    setup_content_item_and_navigation_helpers(@page)
  end

  def top_level_browse_page
    @page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(@page)

    respond_to do |f|
      f.html
      f.json do
        render json: { html: second_level_browse_pages_partial(@page) }
      end
    end
  end

  def second_level_browse_page
    @page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}")
    @meta_section = @page.active_top_level_browse_page.title.downcase
    setup_content_item_and_navigation_helpers(@page)

    respond_to do |f|
      f.html
      f.json do
        render json: { html: render_partial('_links') }
      end
    end
  end

private

  def second_level_browse_pages_partial(page)
    render_partial('_second_level_browse_pages',
      title: page.title,
      second_level_browse_pages: page.second_level_browse_pages,
      curated_order: page.second_level_pages_curated?,
    )
  end

  def render_partial(partial_name, locals = {})
    render_to_string(partial_name, formats: 'html', layout: false, locals: locals)
  end
end
