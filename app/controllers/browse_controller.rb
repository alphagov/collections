class BrowseController < ApplicationController
  enable_request_formats show: [:json]

  def index
    page = MainstreamBrowsePage.find("/browse")
    setup_content_item_and_navigation_helpers(page)

    render :index, locals: { page: page }
  end

  def show
    page =
      MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.html do
        is_page_under_ab_test = false
        ab_test_variant = GovukAbTesting::AbTest.new("EducationNavigation").requested_variant(request)

        if new_navigation_enabled? && params[:top_level_slug] == "education"
          ab_test_variant.configure_response(response)

          if ab_test_variant.variant_b?
            return redirect_to controller: "taxons",
              action: "show",
              taxon_base_path: "education"
          end

          is_page_under_ab_test = true
        end

        render :show, locals: {
          page: page,
          is_page_under_ab_test: is_page_under_ab_test,
          ab_test_variant: ab_test_variant,
         }
      end
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: second_level_browse_pages_partial(page)
        }
      end
    end
  end

private

  def second_level_browse_pages_partial(page)
    render_partial('second_level_browse_page/_second_level_browse_pages',
      title: page.title,
      second_level_browse_pages: page.second_level_browse_pages,
      curated_order: page.second_level_pages_curated?,
    )
  end
end
