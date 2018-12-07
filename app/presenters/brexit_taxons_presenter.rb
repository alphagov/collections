class BrexitTaxonsPresenter
  FEATURED_TAXONS = %w(
    /going-and-being-abroad
    /crime-justice-and-law
    /transport
    /environment
    /business-and-industry
    /education
  ).freeze

  def call
    featured_taxons
  end

  def featured_taxons
    @featured_taxons ||= FEATURED_TAXONS
      .map { |base_path| Taxon.find(base_path) }
      .map { |taxon| BrexitTaxonPresenter.new(taxon) }
  end
end
