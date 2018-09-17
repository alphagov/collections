class TaxonSearchesController < ApplicationController
  def create
    taxon_search = TaxonSearch.new(params[:q])
    taxon_search.fetch
    @results = taxon_search.results
    answer_finder = AnswerFinder.new(params[:q])
    @answer = answer_finder.fetch
    render "create.js.erb"
  end
end