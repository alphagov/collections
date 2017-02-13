class TaxonRedirectResolver
  attr_reader :ab_variant

  def initialize(request, is_page_in_ab_test:, map_to_taxon:)
    @ab_variant = GovukAbTesting::AbTest.new("EducationNavigation").requested_variant(request)
    @is_page_in_ab_test = is_page_in_ab_test
    @map_to_taxon = map_to_taxon
  end

  def page_ab_tested?
    ENV['ENABLE_NEW_NAVIGATION'] == 'yes' && @is_page_in_ab_test.call
  end

  def taxon_base_path
    @map_to_taxon.call if page_ab_tested? && ab_variant.variant_b?
  end
end
