class TransitionLandingPageController < ApplicationController
  include AccountAbTestable
  include Slimmer::Headers

  skip_before_action :set_expiry
  before_action -> { set_expiry(1.minute) }
  before_action :set_account_variant

  around_action :switch_locale

  helper_method :account_variant

  def show
    setup_content_item_and_navigation_helpers(taxon)

    render locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items,
      show_comms: show_comms?,
    }
  end

private

  def taxon
    base_path = request.path
    @taxon ||= begin
      Rails.cache.fetch("collections_content_items#{base_path}", expires_in: 10.minutes) do
        Taxon.find(base_path)
      end
    end
  end

  def presented_taxon
    TransitionLandingPagePresenter.new(taxon)
  end

  def presentable_section_items
    presented_taxon.supergroup_sections.select { |section| section[:show_section] }.map do |section|
      {
        href: "##{section[:id]}",
        text: t(section[:id], scope: :content_purpose_supergroup, default: section[:title]),
      }
    end
  end

  def show_comms?
    true
  end

  def set_account_variant
    return unless Rails.configuration.feature_flag_govuk_accounts
    return unless show_signed_in_header? || show_signed_out_header?

    account_variant.configure_response(response)

    set_slimmer_headers(
      remove_search: true,
      show_accounts: show_signed_in_header? ? "signed-in" : "signed-out",
    )
  end
end
