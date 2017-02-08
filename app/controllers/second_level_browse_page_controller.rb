class SecondLevelBrowsePageController < ApplicationController
  enable_request_formats show: [:json]

  def show
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.html do
        ab_variant = GovukAbTesting::AbTest.new("EducationNavigation").requested_variant(request)

        is_page_under_ab_test = false

        if new_navigation_enabled? && params[:top_level_slug] == "education"
          ab_variant.configure_response(response)
          is_page_under_ab_test = true

          if ab_variant.variant_b?
            taxon = redirects["education"][params[:second_level_slug]]

            return redirect_to controller: "taxons",
              action: "show",
              taxon_base_path: taxon
          end
        end

        render :show, locals: {
          page: page,
          meta_section: meta_section,
          ab_variant: ab_variant,
          is_page_under_ab_test: is_page_under_ab_test
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

  def redirects
    Rails.application.config_for(:navigation_redirects)["second_level_browse_pages"]
  end
end
