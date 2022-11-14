class WorldWideTaxonsController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(taxon)

    taxon_template = presented_taxon.rendering_type

    render taxon_template,
           locals: {
             presented_taxon:,
           }
  end

private

  def taxon
    @taxon ||= WorldWideTaxon.find(request.path)
  end

  def presented_taxon
    @presented_taxon ||= WorldWideTaxonPresenter.new(taxon)
  end
end
