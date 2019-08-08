class BrexitLandingPageController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(taxon)

    render locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items
    }
  end

private

  def taxon
    @taxon ||= Taxon.find(request.path)
  end

  def presented_taxon
    @presented_taxon ||= BrexitLandingPagePresenter.new(taxon)
  end

  def presentable_section_items
    @presentable_section_items = @presented_taxon.supergroup_sections.select { |section| section[:show_section] }.map do |section|
      {
          href: "##{section[:id]}",
          text: t(section[:id], scope: :content_purpose_supergroup, default: section[:title])
      }
    end

    @presentable_section_items
  end
end
