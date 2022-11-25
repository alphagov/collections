class WorldWideTaxonsController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(taxon)

    if taxon.content_item.document_type == "world_location_news"
      @world_location_news = WorldLocationNews.find!(request.path)
      render "world_location_news/show" and return
    end

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
