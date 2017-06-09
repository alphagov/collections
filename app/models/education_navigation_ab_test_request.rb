class EducationNavigationAbTestRequest
  attr_accessor :requested_variant

  delegate :analytics_meta_tag, to: :requested_variant

  def initialize(request)
    dimension = Rails.application.config.navigation_ab_test_dimension
    ab_test = GovukAbTesting::AbTest.new(
      "EducationNavigation",
      dimension: dimension
    )
    @requested_variant = ab_test.requested_variant(request.headers)
  end

  def should_present_new_navigation?
    requested_variant.variant?('B')
  end

  def set_response_vary_header(response)
    requested_variant.configure_response(response)
  end
end
