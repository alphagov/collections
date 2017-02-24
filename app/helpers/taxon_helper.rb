module TaxonHelper
  def taxon_page_rendering_type(taxon)
    if taxon.grandchildren?
      "grid"
    elsif taxon.children?
      "accordion"
    else
      "leaf"
    end
  end
end
