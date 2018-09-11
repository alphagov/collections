class TaxonSearchesController < ApplicationController
  def create
    # @results = Rails.cache.fetch(params[:q]) do
      taxon_search = TaxonSearch.new(params[:q])
      taxon_search.fetch
      @results = taxon_search.results

    # end
    render "create.js.erb"
  end
end
