module TaxonHelper
  def taxon_description(taxon, presented_taxon)
    return taxon.description if taxon.description.present?
    worldwide_news_description(taxon, presented_taxon)
  end

private

  # There is currently no good way to determine whether or not the taxon
  #  is a worldwide news page from the results returned by rummager.
  #  This is because worlwide news pages are just aggregates of publications
  #  relating to a location and rendered by Whitheall.
  #  Use the base_path to decide as follows:
  #   If the taxon has a base_path that ends with the
  #   "<presented_taxon base_path>/news", assume it is a worldwide news item
  def worldwide_news_description(taxon, presented_taxon)
    assumed_news_base_path = presented_taxon.base_path + "/news"
    if taxon.base_path.present? && taxon.base_path.ends_with?(assumed_news_base_path)
      "Updates, news and events from the UK government in #{presented_taxon.title}"
    end
  end
end
