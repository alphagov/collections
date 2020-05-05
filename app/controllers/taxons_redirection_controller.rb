class TaxonsRedirectionController < ApplicationController
  CORONAVIRUS_LANDING_PAGE_PATH = "/coronavirus".freeze
  CORONAVIRUS_TAXON_PATH = "/coronavirus-taxon".freeze

  CORONAVIRUS_BUSINESS_TAXON_CONTENT_ID = "65666cdf-b177-4d79-9687-b9c32805e450".freeze
  CORONAVIRUS_EDUCATION_TAXON_CONTENT_ID = "272308f4-05c8-4d0d-abc7-b7c2e3ccd249".freeze

  HUB_PAGE_FROM_CONTENT_ID = {
    CORONAVIRUS_BUSINESS_TAXON_CONTENT_ID => "/coronavirus/business-support",
    CORONAVIRUS_EDUCATION_TAXON_CONTENT_ID => "/coronavirus/education-and-childcare",
  }.freeze

  def redirect
    if is_coronavirus_taxon?
      redirect_to_landing_page && return
    else
      redirect_to_best_coronavirus_page
    end
  end

private

  def redirect_to_landing_page
    redirect_to(CORONAVIRUS_LANDING_PAGE_PATH, status: :temporary_redirect)
  end

  def redirect_to_best_coronavirus_page
    redirect_to(best_coronavirus_page, status: :temporary_redirect)
  end

  def best_coronavirus_page
    return HUB_PAGE_FROM_CONTENT_ID[taxon.content_id] if hub_taxon?
    return HUB_PAGE_FROM_CONTENT_ID[parent_hub_taxons.first] if parent_hub_taxons.any?

    CORONAVIRUS_LANDING_PAGE_PATH
  end

  def hub_taxon?
    hub_taxon_content_ids.include?(taxon.content_id)
  end

  def parent_hub_taxons
    hub_taxon_content_ids & taxon.parent_taxons.map(&:content_id)
  end

  def hub_taxon_content_ids
    HUB_PAGE_FROM_CONTENT_ID.keys
  end

  def taxon
    @taxon ||= Taxon.find(request.path)
  end

  def is_coronavirus_taxon?
    request.path == CORONAVIRUS_TAXON_PATH
  end
end
