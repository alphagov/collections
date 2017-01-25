class TopLevelBrowsePageController < ApplicationController
  enable_request_formats show: [:json]

  def show
    @page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(@page)

    respond_to do |f|
      f.html
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: second_level_browse_pages_partial(@page)
        }
      end
    end
  end

private

  # TODO: move this to app controller
  def breadcrumb_content
    render_partial(
      '_breadcrumbs',
      navigation_helpers: @navigation_helpers
    )
  end

  def second_level_browse_pages_partial(page)
    render_partial('browse/_second_level_browse_pages',
      title: page.title,
      second_level_browse_pages: page.second_level_browse_pages,
      curated_order: page.second_level_pages_curated?,
    )
  end

  # move this to app controller
  def render_partial(partial_name, locals = {})
    render_to_string(partial_name, formats: 'html', layout: false, locals: locals)
  end
end
