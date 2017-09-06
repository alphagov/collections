class TaxonRedirectResolver
  attr_reader :taxon_base_path, :fragment

  def initialize(ab_variant, page_is_in_ab_test:, map_to_taxon:)
    if page_is_in_ab_test && ab_variant.variant?('B')
      @taxon_base_path, @fragment = map_to_taxon.split('#')
    end
  end
end
