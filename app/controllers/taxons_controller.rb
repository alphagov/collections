class TaxonsController < ApplicationController
  include TaxonPagesTestable

  def show
    setup_content_item_and_navigation_helpers(taxon)

    render :show, locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items
    }
  end

private

  def taxon
    @taxon ||= Taxon.find(request.path)
  end

  def presented_taxon
    @presented_taxon ||= TaxonPresenter.new(taxon)
  end

  def presentable_section_items
    section_items = @presented_taxon.sections.select { |section| section[:show_section] }.map do |section|
      {
          href: "##{section[:id]}",
          text: t(section[:id], scope: :content_purpose_supergroup, default: section[:title])
      }
    end

    section_items << { href: "#organisations", text: t('taxons.organisations') }

    if presented_taxon.show_subtopic_grid?
      section_items << { href: "#sub-topics", text: t('taxons.sub_topics') }
    end

    section_items
  end
end
