class BrexitTaxonPresenter
  attr_reader :taxon
  delegate(
    :title,
    :base_path,
    to: :taxon
  )

  def initialize(taxon, index = false)
    @taxon = taxon
    @index = index if index
  end

  def description
    I18n.t("campaign.taxon_descriptions.#{taxon.base_path.delete('/')}")
  end

  def finder_link
    "https://finder-frontend-pr-706.herokuapp.com/prepare-individual-uk-leaving-eu?topic=#{taxon.base_path}"
  end

  def data_attributes
    {
      "track-category": "navGridContentClicked",
      "track-action": @index,
      "track-label": taxon.title
    }
  end
end
