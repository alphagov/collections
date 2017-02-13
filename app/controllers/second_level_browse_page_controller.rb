class SecondLevelBrowsePageController < ApplicationController
  enable_request_formats show: [:json]

  def show
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.html do
        show_html
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

  def show_html
    taxon_resolver = TaxonRedirectResolver.new(
      request,
      is_page_in_ab_test: lambda { params[:top_level_slug] == "education" },
      map_to_taxon: lambda { redirects["education"][params[:second_level_slug]] }
    )

    if taxon_resolver.page_ab_tested?
      taxon_resolver.ab_variant.configure_response(response)
    end

    if taxon_resolver.taxon_base_path
      redirect_to controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path
    else
      render :show, locals: {
        page: page,
        meta_section: meta_section,
        is_page_under_ab_test: taxon_resolver.page_ab_tested?,
        ab_variant: taxon_resolver.ab_variant,
      }
    end
  end

  def redirects
    Rails.application.config_for(:navigation_redirects)["second_level_browse_pages"]
  end

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
