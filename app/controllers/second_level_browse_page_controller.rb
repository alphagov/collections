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
      ab_variant,
      page_is_in_ab_test: page_in_ab_test?,
      map_to_taxon: second_level_redirect
    )

    configure_ab_response if page_in_ab_test?

    if taxon_resolver.redirect?
      redirect_to(
        controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path,
        anchor: taxon_resolver.fragment
      )
    else
      render :show, locals: {
        page: page,
        meta_section: meta_section,
        is_page_under_ab_test: page_in_ab_test?,
        ab_variant: ab_variant,
      }
    end
  end

  def page_in_ab_test?
    top_level_redirect.present? && second_level_redirect.present?
  end

  def top_level_redirect
    redirects[params[:top_level_slug]]
  end

  def second_level_redirect
    redirects.dig(params[:top_level_slug], params[:second_level_slug])
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
end
