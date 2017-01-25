class SecondLevelBrowsePageController < ApplicationController
  enable_request_formats show: [:json]

  def show
    setup_navigation_helpers(content_item)

    respond_to do |f|
      f.html do
        render :show, locals: {
          content_item: content_item,
          meta_section: meta_section
        }
      end
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: render_partial('_links', content_item: content_item)
        }
      end
    end
  end

private

  def meta_section
    content_item.active_top_level_browse_page.title.downcase
  end

  def content_item
    MainstreamBrowsePage.find(
      "/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}"
    )
  end
end
