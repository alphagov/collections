class BrowseController < ApplicationController
  enable_request_formats show: [:json]

  def index
    page = MainstreamBrowsePage.find("/browse")
    setup_content_item_and_navigation_helpers(page)

    render :index, locals: {
      page: page,
      ab_variant: education_ab_test.requested_variant
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
          breadcrumbs: breadcrumb_content,
          html: second_level_browse_pages_partial(page)
        }
      end
    end
  end

private

  def show_html(page)
    taxon_resolver = TaxonRedirectResolver.new(
      request,
      is_page_in_ab_test: lambda { params[:top_level_slug] == "education" },
      map_to_taxon: lambda { "education" }
    )

    if taxon_resolver.page_ab_tested?
      taxon_resolver.ab_variant.configure_response(response)
    end

    if taxon_resolver.taxon_base_path
      redirect_to(
        controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path,
        anchor: taxon_resolver.fragment
      )
    else
      render :show, locals: {
        page: page,
        is_page_under_ab_test: taxon_resolver.page_ab_tested?,
        ab_variant: taxon_resolver.ab_variant,
      }
    end
  end

  def second_level_browse_pages_partial(page)
    render_partial('second_level_browse_page/_second_level_browse_pages',
      title: page.title,
      second_level_browse_pages: page.second_level_browse_pages,
      curated_order: page.second_level_pages_curated?,
    )
  end
end
