class TaxonRedirectResolver
  attr_reader :taxon_base_path, :fragment

  def initialize(ab_variant, is_page_in_ab_test:, map_to_taxon:)
    @is_page_in_ab_test = is_page_in_ab_test
    @map_to_taxon = map_to_taxon

    if page_ab_tested? && ab_variant.variant?('B')
      @taxon_base_path, @fragment = @map_to_taxon.call.split('#')
    end
  end

  def page_ab_tested?
    @is_page_in_ab_test.call
  end
end
