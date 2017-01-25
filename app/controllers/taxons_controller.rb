class TaxonsController < ApplicationController
  before_action :return_404, unless: :new_navigaton_enabled?

  def show
    setup_navigation_helpers(taxon)

    render :show, locals: { taxon: taxon }
  end

private

  def new_navigaton_enabled?
    ENV['ENABLE_NEW_NAVIGATION'] == 'yes'
  end

  def return_404
    head :not_found
  end

  def taxon
    @taxon ||= Taxon.find(request.path)
  end
end
