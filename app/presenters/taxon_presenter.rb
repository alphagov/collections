class TaxonPresenter
  GRID = 1
  ACCORDION = 2
  LEAF = 3

  attr_reader :taxon
  delegate :tagged_content, to: :taxon

  def initialize(taxon)
    @taxon = taxon
  end

  def rendering_type
    return GRID if taxon.grandchildren?

    taxon.children? ? ACCORDION : LEAF
  end

  def renders_as_accordion?
    rendering_type == ACCORDION
  end

  def renders_as_leaf?
    rendering_type == LEAF
  end

  def renders_as_grid?
    rendering_type == GRID
  end
end
