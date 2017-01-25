class BrowseController < ApplicationController
  enable_request_formats show: [:json]

  def index
    content_item = MainstreamBrowsePage.find("/browse")
    setup_navigation_helpers(content_item)

    render :index, locals: { content_item: content_item }
  end

  def show
    content_item =
      MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_navigation_helpers(content_item)

    respond_to do |f|
      f.html do
        render :show, locals: { content_item: content_item }
      end
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: second_level_browse_pages_partial(content_item)
        }
      end
    end
  end

private

  def second_level_browse_pages_partial(content_item)
    render_partial('second_level_browse_page/_second_level_browse_pages',
      title: content_item.title,
      second_level_browse_pages: content_item.second_level_browse_pages,
      curated_order: content_item.second_level_pages_curated?,
    )
  end
end
