class BrexitTaxonsPresenter
  FEATURED_TAXONS = %w(
    /going-and-being-abroad
    /health-and-social-care
    /transport
    /environment
    /business-and-industry
    /education
    /crime-justice-and-law
  ).freeze

  def call
    featured_taxons
  end

  def featured_taxons
    @featured_taxons ||= FEATURED_TAXONS
      .map { |base_path| Taxon.find(base_path) }
      .map { |taxon| BrexitCampaignPresenter.new(taxon) }
      .sort_by { |taxon| FEATURED_TAXONS.index(taxon.base_path) }
  end
end