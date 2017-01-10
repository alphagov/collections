class TaxonsController < ApplicationController
  before_action :redirect_to_www, unless: :new_navigaton_enabled?

  def show
    render :show, locals: {
      taxon: taxon,
      parent_taxon: taxon.parent_taxon,
      child_taxons: taxon.child_taxons,
      navigation_helpers: navigation_helpers,
      tagged_content: search.documents
    }
  end

private

  def new_navigaton_enabled?
    Rails.env.test? ||
      Rails.env.development? ||
      ENV['ENABLE_NEW_NAVIGATION'] == 'yes'
  end

  def redirect_to_www
    redirect_to Plek.find('www')
  end

  def search
    RummagerSearch.new(
      filter_taxons: [taxon.content_id],
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w(title link)
    )
  end

  def taxon
    @taxon ||= begin
      taxon_base_path = params[:taxon_base_path]
      Taxon.find('/alpha-taxonomy/' + taxon_base_path)
    end
  end

  def navigation_helpers
    @navigation_helpers ||= begin
      content_item = taxon.content_item.content_item_data
      GovukNavigationHelpers::NavigationHelper.new(content_item)
    end
  end
end
