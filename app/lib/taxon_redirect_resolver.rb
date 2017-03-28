class TaxonRedirectResolver
  attr_reader :ab_variant, :taxon_base_path, :fragment

  def initialize(request, is_page_in_ab_test:, map_to_taxon:)
    dimension = Rails.application.config.navigation_ab_test_dimension
    ab_test = GovukAbTesting::AbTest.new("EducationNavigation", dimension: dimension)
    @ab_variant = ab_test.requested_variant(request.headers)

    @is_page_in_ab_test = is_page_in_ab_test
    @map_to_taxon = map_to_taxon

    if page_ab_tested? && ab_variant.variant_b?
      @taxon_base_path, @fragment = @map_to_taxon.call.split('#')
    end
  end

  def page_ab_tested?
    @is_page_in_ab_test.call
  end
end
