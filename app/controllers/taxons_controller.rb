class TaxonsController < ApplicationController
  before_action :return_404, unless: :new_navigation_enabled?

  def show
    setup_content_item_and_navigation_helpers(taxon)

    render :show, locals: { taxon: taxon }
  end

private

  def return_404
    head :not_found
  end

  def taxon
    @taxon ||= Taxon.find(request.path)
  end
end
