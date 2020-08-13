class TransitionLandingPageController < ApplicationController
  skip_before_action :set_expiry
  before_action -> { set_expiry(1.minute) }

  around_action :switch_locale

  def show
    setup_content_item_and_navigation_helpers(taxon)

    ab_test_variant.configure_response(response) if page_under_test?

    render locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items,
      show_comms: show_comms?,
    }
  end

private

  def taxon
    Taxon.find(request.path)
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

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  helper_method :ab_test_variant, :page_under_test?, :show_variant?
  def ab_test_variant
    @ab_test_variant ||= begin
      ab_test = GovukAbTesting::AbTest.new(
        "TransitionChecker2",
        dimension: 44,
        allowed_variants: %w[A B Z],
        control_variant: "Z",
      )
      ab_test.requested_variant(request.headers)
    end
  end

  def page_under_test?
    request.path == "/transition"
  end

  def show_variant?
    page_under_test? && ab_test_variant.variant?("B")
  end
end
