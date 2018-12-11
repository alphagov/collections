class BrexitTaxonPresenter
  attr_reader :taxon_content_item
  delegate(
    :title,
    :base_path,
    to: :taxon_content_item
  )

  def initialize(taxon_content_item, index = nil)
    @taxon_content_item = taxon_content_item
    @index = index
  end

  def description
    I18n.t("campaign.taxon_descriptions.#{taxon_content_item.base_path.delete('/')}")
  end

  def finder_link
    "/prepare-eu-exit#{taxon_content_item.base_path}"
  end

  def data_attributes
    {
      "track-category": "navGridContentClicked",
      "track-action": @index,
      "track-label": taxon_content_item.title
    }
  end
end
