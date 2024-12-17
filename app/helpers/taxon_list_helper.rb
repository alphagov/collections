module TaxonListHelper
  def taxon_list_params(presented_taxon)
    presented_taxon.tagged_content.each.map do |content_item|
      {
        link: {
          path: content_item.base_path,
          text: content_item.title,
          description: content_item.description,
          full_size_description: true,
        },
      }
    end
  end
end
