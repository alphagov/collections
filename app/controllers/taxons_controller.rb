class TaxonsController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(taxon)

    taxon_template =
      case presented_taxon.rendering_type
      when TaxonPresenter::GRID
        :grid
      when TaxonPresenter::ACCORDION
        :accordion
      else
        :leaf
      end

    # Show the taxon page regardless of which variant is requested, because
    # there is no straighforward mapping of taxons back to original navigation
    # pages.
    render taxon_template, locals: {
      presented_taxon: presented_taxon,
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
end
