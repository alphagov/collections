class TaxonsController < ApplicationController
  helper_method :taxon_overview_and_child_taxons

  def show
    setup_content_item_and_navigation_helpers(taxon)

    # Show the taxon page regardless of which variant is requested, because
    # there is no straighforward mapping of taxons back to original navigation
    # pages.
    render :show, locals: {
      taxon: taxon,
      ab_variant: education_ab_test.requested_variant
    }
  end

private

  def taxon
    @taxon ||= Taxon.find(request.path)
  end

  def taxon_overview_and_child_taxons(taxon)
    accordion_items = taxon.child_taxons
    return [] if taxon.child_taxons.empty?

    current_taxon_title = 'General information and guidance'

    if taxon.tagged_content.count > 0
      accordion_items.unshift(
        taxon.merge(
          'title' => current_taxon_title,
          'description' => '',
          'base_path' => current_taxon_title.downcase.tr(' ', '-'),
        )
      )
    end

    accordion_items
  end
end
