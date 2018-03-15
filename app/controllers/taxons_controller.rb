class TaxonsController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(taxon)
    render :show, locals: {
      presented_taxon: presented_taxon
    }
  end

private

  def taxon
    @taxon ||= Taxon.find(request.path)
  end

  def presented_taxon
    @presented_taxon ||= TaxonPresenter.new(taxon)
  end
end
