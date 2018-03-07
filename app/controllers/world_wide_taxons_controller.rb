class WorldWideTaxonsController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(taxon)

    taxon_template =
      case presented_taxon.rendering_type
      when WorldWideTaxonPresenter::ACCORDION
        :accordion
      else
        :leaf
      end

    render taxon_template, locals: {
      presented_taxon: presented_taxon
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
