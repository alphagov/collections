class BrexitLandingPageController < ApplicationController
  include GovukPersonalisation::ControllerConcern
  include Slimmer::Headers

  skip_before_action :set_expiry
  before_action -> { set_expiry(1.minute) }
  before_action -> { set_slimmer_headers(remove_search: true, show_accounts: logged_in? ? "signed-in" : "signed-out") }
  after_action :set_slimmer_template

  around_action :switch_locale
  def show
    setup_content_item_and_navigation_helpers(taxon)

    render locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items,
    }
  end

private

  def set_slimmer_template
    slimmer_template "gem_layout_full_width"
  end

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
