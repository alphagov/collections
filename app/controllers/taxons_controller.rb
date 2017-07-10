class TaxonsController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(taxon)

    taxon_template =
      case presented_taxon.rendering_type
      when TaxonPresenter::GRID
        :grid
      when TaxonPresenter::ACCORDION
        :accordion
      else
        :leaf
      end

    # Show the taxon page regardless of which variant is requested, because
    # there is no straighforward mapping of taxons back to original navigation
    # pages.
    render taxon_template, locals: {
      presented_taxon: presented_taxon,
      education_ab_test: education_ab_test
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
