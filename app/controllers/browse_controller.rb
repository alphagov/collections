class BrowseController < ApplicationController
  enable_request_formats show: [:json]

  def index
    page = MainstreamBrowsePage.find("/browse")
    @dimension26 = 1
    @dimension27 = page.top_level_browse_pages.count || 0
    setup_content_item_and_navigation_helpers(page)

    render :index,
           locals: {
             page: page,
           }
  end

  def show
    page =
      MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.html do
        show_html(page)
      end
      f.json do
        render json: {
          content_id: page.content_id,
          navigation_page_type: "First Level Browse",
          breadcrumbs: breadcrumb_content,
          html: second_level_browse_pages_partial(page),
        }
      end
    end
  end

private

  def show_html(page)
    render :show,
           locals: {
             page: page,
           }
  end

  def second_level_browse_pages_partial(page)
    render_partial(
      "second_level_browse_page/_second_level_browse_pages",
      title: page.title,
      second_level_browse_pages: page.second_level_browse_pages,
      curated_order: page.second_level_pages_curated?,
    )
  end
end
