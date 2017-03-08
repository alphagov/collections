class TaxonsController < ApplicationController
  before_action :return_404, unless: :new_navigation_enabled?

  helper_method :taxon_overview_and_child_taxons

  def show
    setup_content_item_and_navigation_helpers(taxon)

    # Show the taxon page regardless of which variant is requested, because
    # there is no straighforward mapping of taxons back to original navigation
    # pages.
    render :show, locals: { taxon: taxon, ab_variant: ab_variant }
  end

private

  def dimension
    Rails.application.config.navigation_ab_test_dimension
  end

  def ab_variant
    @ab_variant ||= begin
      ab_test =
        GovukAbTesting::AbTest.new("EducationNavigation", dimension: dimension)
      variant = ab_test.requested_variant(request.headers)
      variant.configure_response(response)

      variant
    end
  end

  def new_navigation_enabled?
    ab_variant.variant_b?
  end

  def return_404
    head :not_found
  end

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
