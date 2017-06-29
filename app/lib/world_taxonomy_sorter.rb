class WorldTaxonomySorter
  WORLD_TAXONOMY_ORDER = [
    "Emergency help for British nationals",
    "Brexit",
    "Passports and emergency travel documents",
    "Travelling to",
    "Coming to the UK",
    "Living in",
    "Tax, benefits, pensions and working abroad",
    "Birth, death and marriage abroad",
    "News and events",
    "Trade and invest",
    "British embassy or high commission",
  ].freeze

  def self.call(child_taxons)
    ordered_taxons = WORLD_TAXONOMY_ORDER.map do |title|
      # Using `starts_with?` as opposed to `==` here as we do not know the name
      # the COUNTRY for 'Travelling to COUNTRY' or 'Living in COUNTRY'
      child_taxons.find { |taxon| taxon.title.starts_with?(title) }
    end

    # remove nils and append the taxons with titles not in the order list
    ordered_taxons.compact.concat(child_taxons - ordered_taxons)
  end
end
