class BrexitLandingPageController < ApplicationController
  # 68 was chosen to uniquely identify BrexitLandingPageTest in GA
  CUSTOM_DIMENSION = 68

  helper_method :page_variant

  def show
    setup_content_item_and_navigation_helpers(taxon)

    render locals: {
      presented_taxon: presented_taxon,
      presentable_section_items: presentable_section_items,
      show_dynamic_list: show_dynamic_list?,
    }

    page_variant.configure_response(response)
  end

private

  def page_variant
    @page_variant ||= begin
                        ab_test = GovukAbTesting::AbTest.new(
                          "BrexitLandingPageTest",
                          dimension: CUSTOM_DIMENSION,
                          allowed_variants: %w(A B),
                          control_variant: "A",
                        )

                        ab_test.requested_variant(request.headers)
                      end
  end

  def taxon
    Taxon.find(request.path)
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

  def show_dynamic_list?
    true
  end
end
