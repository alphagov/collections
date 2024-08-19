module PopularTasksAbTestable
  extend ActiveSupport::Concern

  ALLOWED_VARIANTS = %w[A B C Z].freeze

  included do
    helper_method(
      :popular_tasks_variant,
      :popular_tasks_page_under_test?,
      :popular_tasks_variant_a_page?,
      :popular_tasks_variant_b_page?,
    )
    after_action :set_popular_tasks_ab_test_response_header
  end

  def popular_tasks_ab_test
    @popular_tasks_ab_test ||= GovukAbTesting::AbTest.new(
      "PopularTasks",
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def popular_tasks_variant
    @popular_tasks_variant ||= popular_tasks_ab_test.requested_variant(request.headers)
  end

  def popular_tasks_page_under_test?
    request.path.match?(%r{\A/browse/[^/]+\z})
  end

  def set_popular_tasks_ab_test_response_header
    popular_tasks_variant.configure_response(response) if popular_tasks_page_under_test?
  end

  def popular_tasks_variant_a_page?
    popular_tasks_page_under_test? && popular_tasks_variant.variant?("A")
  end

  def popular_tasks_variant_b_page?
    popular_tasks_page_under_test? && popular_tasks_variant.variant?("B")
  end
end
