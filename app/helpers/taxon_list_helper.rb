module TaxonListHelper
  def taxon_list_params(presented_taxon, data_options_type:, section_index: nil)
    presented_taxon.tagged_content.each_with_index.map do |content_item, index|
      data_attributes = if section_index
                          presented_taxon.send(data_options_type, index:, section_index:)
                        else
                          presented_taxon.send(data_options_type, index:)
                        end

      {
        path: content_item.base_path,
        text: content_item.title,
        data_attributes:,
        description: content_item.description,
      }
    end
  end
end
