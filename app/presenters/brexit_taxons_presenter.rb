class BrexitTaxonsPresenter
  FEATURED_TAXONS = %w(
    /going-and-being-abroad
    /work
    /transport
    /environment
    /business-and-industry
    /education
  ).freeze

  REJECTED_TAXONS = %w(
    /government/all
  ).freeze

  def featured_taxons
    @featured_taxons ||= FEATURED_TAXONS
      .to_enum
      .with_index(1)
      .map do |base_path, index|
        content_item = ContentItem.find!(base_path)

        BrexitTaxonPresenter.new(content_item, index)
      end
  end

  def other_taxons
    @other_taxons ||= ContentItem.find!('/')
      .linked_items('level_one_taxons')
      .reject { |content_item| FEATURED_TAXONS.include?(content_item.base_path) }
      .reject { |content_item| REJECTED_TAXONS.include?(content_item.base_path) }
      .select { |content_item| search_response_including_brexit(content_item.content_id, document_types).total.positive? }
      .map { |content_item| BrexitTaxonPresenter.new(content_item) }
  end

private

  def search_response_including_brexit(content_id, filter_content_store_document_type)
    params = {
      count: 1,
      fields: %w(title link),
      filter_all_part_of_taxonomy_tree: [content_id, 'd7bdaee2-8ea5-460e-b00d-6e9382eb6b61'],
      filter_content_store_document_type: filter_content_store_document_type
    }
    RummagerSearch.new(params)
  end

  def document_types
    %w(travel_advice_index) + GovukDocumentTypes.supergroup_document_types('guidance_and_regulation', 'services')
  end
end
