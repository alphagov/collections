class TaxonsController < ApplicationController
  helper_method :taxon_overview_and_child_taxons

  def show
    setup_content_item_and_navigation_helpers(taxon)

    # Show the taxon page regardless of which variant is requested, because
    # there is no straighforward mapping of taxons back to original navigation
    # pages.
    render :show, locals: {
      taxon: taxon,
      blue_box_ab_test: blue_box_ab_test,
      education_ab_test: education_ab_test
    }
  end

private

  def blue_box_ab_test
    @blue_box_ab_test ||= begin
      blue_box_ab_test = BlueBoxAbTestRequest.new(request, presented_taxon)
      blue_box_ab_test.set_response_vary_header(response)
      blue_box_ab_test
    end
  end

  def taxon
    @taxon ||= Taxon.find(request.path)
  end

  def presented_taxon
    @presented_taxon ||= TaxonPresenter.new(taxon)
  end

  def taxon_overview_and_child_taxons(taxon)
    accordion_items = taxon.child_taxons
    return [] if taxon.child_taxons.empty?

    current_taxon_title = 'General information and guidance'

    if taxon.tagged_content.count > 0
      general_information = Taxon.new(
        ContentItem.new(
          'content_id' => taxon.content_id,
          'title' => current_taxon_title,
          'base_path' => current_taxon_title.downcase.tr(' ', '-'),
          'description' => ''
        )
      )
      general_information.can_subscribe = false

      accordion_items.unshift(
        general_information
      )
    end

    accordion_items
  end
end
