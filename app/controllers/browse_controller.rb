class BrowseController < ApplicationController
  enable_request_formats show: [:json]

  def index
    page = MainstreamBrowsePage.find("/browse")
    setup_content_item_and_navigation_helpers(page)

    dimension = Rails.application.config.navigation_ab_test_dimension
    ab_test = GovukAbTesting::AbTest.new("EducationNavigation", dimension: dimension)
    ab_variant = ab_test.requested_variant(request)

    render :index, locals: { page: page, ab_variant: ab_variant }
  end

  def show
    page =
      MainstreamBrowsePage.find("/browse/#{params[:top_level_slug]}")
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.html do
        is_page_under_ab_test = false

        dimension = Rails.application.config.navigation_ab_test_dimension
        ab_test = GovukAbTesting::AbTest.new("EducationNavigation", dimension: dimension)
        ab_variant = ab_test.requested_variant(request)

        if new_navigation_enabled? && params[:top_level_slug] == "education"
          ab_variant.configure_response(response)

          if ab_variant.variant_b?
            return redirect_to controller: "taxons",
              action: "show",
              taxon_base_path: "education"
          end

          is_page_under_ab_test = true
        end

        render :show, locals: {
          page: page,
          is_page_under_ab_test: is_page_under_ab_test,
          ab_variant: ab_variant,
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
