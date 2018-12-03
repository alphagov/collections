class BrexitTaxonPresenter
  attr_reader :taxon
  delegate(
    :title,
    :base_path,
    to: :taxon
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def description
    I18n.t("campaign.taxon_descriptions.#{taxon.base_path.delete('/')}")
  end

  def finder_link
    "/prepare-eu-exit-live-uk#{taxon.base_path}"
  end
end
