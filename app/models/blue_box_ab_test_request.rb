class BlueBoxAbTestRequest
  MINIMUM_DOCUMENTS_TAGGED = 15

  attr_reader :presented_taxon, :requested_variant

  delegate :analytics_meta_tag, to: :requested_variant

  def initialize(request, presented_taxon)
    @presented_taxon = presented_taxon
    @ab_test = GovukAbTesting::AbTest.new("NavigationTest", dimension: '61')
    @requested_variant = @ab_test.requested_variant(request.headers)
  end

  def ab_test_applies?
    presented_taxon.renders_as_accordion? ||
      presented_taxon.tagged_content.length >= MINIMUM_DOCUMENTS_TAGGED
  end

  def should_present?
    ab_test_applies? && requested_variant.variant_b?
  end

  def set_response_vary_header(response)
    requested_variant.configure_response(response)
  end
end
