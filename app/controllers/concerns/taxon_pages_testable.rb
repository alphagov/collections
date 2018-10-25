module TaxonPagesTestable
  CUSTOM_DIMENSION = 65

  def self.included(base)
    base.helper_method(
      :taxon_page_variant,
      :is_testable_taxon_page?,
      :variant_section_partial
    )
    base.after_action :set_test_response_header
  end

  def taxon_page_variant
    @taxon_page_variant ||= taxon_page_test.requested_variant(request.headers)
  end

  def is_testable_taxon_page?
    true
  end

private

  def taxon_page_test
    @taxon_page_test ||= GovukAbTesting::AbTest.new(
      "TopicPagesTest",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: %w(A B C D E),
      control_variant: "A"
    )
  end

  def set_test_response_header
    taxon_page_variant.configure_response(response)
  end
end
