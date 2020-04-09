class TaxonsController < ApplicationController
  CORONAVIRUS_TAXON_PATH = "/coronavirus-taxon".freeze
  before_action :redirect_coronavirus_taxons
  rescue_from Taxon::InAlphaPhase, with: :error_404

  def show
    setup_content_item_and_navigation_helpers(taxon)

    render locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items,
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
    @presentable_section_items = @presented_taxon.sections.select { |section| section[:show_section] }.map do |section|
      {
          href: "##{section[:id]}",
          text: t(section[:id], scope: :content_purpose_supergroup, default: section[:title]),
      }
    end

    @presentable_section_items << { href: "#organisations", text: t("taxons.organisations") }

    if presented_taxon.show_subtopic_grid?
      @presentable_section_items << { href: "#sub-topics", text: t("taxons.explore_sub_topics") }
    end

    @presentable_section_items
  end

  def redirect_coronavirus_taxons
    if is_child_of_coronavirus_taxon? || is_coronavirus_taxon?
      redirect_to(coronavirus_landing_page_url, status: :temporary_redirect) && return
    end
  end

  def is_child_of_coronavirus_taxon?
    # The root of the branch is always the first entry
    taxon.parents? && taxon.parent_taxons.first.base_path == CORONAVIRUS_TAXON_PATH
  end

  def is_coronavirus_taxon?
    # The root of the branch is always the first entry
    taxon.base_path == CORONAVIRUS_TAXON_PATH
  end
end
