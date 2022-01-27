class BrexitLandingPageController < ApplicationController
  include Slimmer::Headers

  skip_before_action :set_expiry
  before_action do
    set_expiry content_item.max_age, public_cache: content_item.public_cache
  end

  slimmer_template "gem_layout_full_width_explore_header"

  around_action :switch_locale
  def show
    setup_content_item_and_navigation_helpers(taxon)

    @content_item.merge!(
      "navigation_page_type" => "Taxon Page",
      "title" => t("brexit_landing_page.meta_title"),
      "description" => t("brexit_landing_page.meta_description"),
    )

    render locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items,
    }
  end

private

  def taxon
    base_path = request.path
    @taxon ||= Rails.cache.fetch("collections_content_items#{base_path}", expires_in: 10.minutes) do
      Taxon.find(base_path)
    end
  end

  def presented_taxon
    BrexitLandingPagePresenter.new(taxon)
  end

  def presentable_section_items
    presented_taxon.supergroup_sections.select { |section| section[:show_section] }.map do |section|
      {
        href: "##{section[:id]}",
        text: t(section[:id], scope: :content_purpose_supergroup, default: section[:title]),
      }
    end
  end
end
