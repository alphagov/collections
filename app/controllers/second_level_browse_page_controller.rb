class SecondLevelBrowsePageController < ApplicationController
  enable_request_formats show: [:json]

  def show
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.html do
        ab_variant = GovukAbTesting::AbTest.new("EducationNavigation").requested_variant(request)
        render :show, locals: {
          page: page,
          meta_section: meta_section,
          ab_variant: ab_variant
        }
      end
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: render_partial('_links', page: page)
        }
      end
    end
  end

private

  def meta_section
    page.active_top_level_browse_page.title.downcase
  end

  def page
    MainstreamBrowsePage.find(
      "/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}"
    )
  end
end
