class CoronavirusLandingPageController < ApplicationController
  slimmer_template "gem_layout_full_width"

  def show
    breadcrumbs = [{ title: t("shared.breadcrumbs_home"), url: "/", is_page_parent: true }]

    ab_test = GovukAbTesting::AbTest.new(
      "UxmPracticeTest",
      dimension: 68,
      allowed_variants: %w[A B Z],
      control_variant: "Z",
    )

    @requested_variant = ab_test.requested_variant(request.headers)
    @requested_variant.configure_response(response)

    render "show",
           locals: {
             breadcrumbs:,
             details: presenter,
             special_announcement:,
           }
  end

private

  def set_slimmer_template
    set_gem_layout_full_width
  end

  def content_item
    @content_item ||= ContentItem.find!(request.path)
  end

  def presenter
    @presenter ||= CoronavirusLandingPagePresenter.new(content_item.to_hash)
  end

  def special_announcement
    @special_announcement ||= SpecialAnnouncementPresenter.new(content_item.to_hash)
  end
end
