class SecondLevelBrowsePageController < ApplicationController
  enable_request_formats show: [:json]

  def show
    @page = MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}")
    @meta_section = @page.active_top_level_browse_page.title.downcase
    setup_content_item_and_navigation_helpers(@page)

    respond_to do |f|
      f.html
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: render_partial('_links')
        }
      end
    end
  end

private

  def breadcrumb_content
    render_partial(
      '_breadcrumbs',
      navigation_helpers: @navigation_helpers
    )
  end

  def render_partial(partial_name, locals = {})
    render_to_string(partial_name, formats: 'html', layout: false, locals: locals)
  end
end
