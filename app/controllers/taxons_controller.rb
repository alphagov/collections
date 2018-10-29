class TaxonsController < ApplicationController
  include TaxonPagesTestable

  def show
    setup_content_item_and_navigation_helpers(taxon)
    render "show_#{taxon_page_variant.variant_name.downcase}", locals: {
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
