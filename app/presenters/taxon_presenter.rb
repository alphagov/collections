class TaxonPresenter
  GRID = :grid
  ACCORDION = :accordion
  LEAF = :leaf

  attr_reader :taxon
  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :tagged_content,
    :grandchildren?,
    :child_taxons,
    :live_taxon?,
    :guidance_and_regulation_content,
    :services_content,
    :most_popular_content,
    :can_subscribe?,
    to: :taxon
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def guidance_and_regulation_list
    guidance_and_regulation_content.each.map do |link|
      {
        link: {
          text: link.title,
          path: link.base_path
        },
        metadata: {
          public_updated_at: link.public_updated_at,
          document_type: link.content_store_document_type.humanize
        },
      }
    end
  end

  def guidance_and_regulation_section_title
    'guidance_and_regulation'.humanize
  end

  def rendering_type
    return GRID if taxon.grandchildren?

    taxon.children? ? ACCORDION : LEAF
  end

  def renders_as_accordion?
    rendering_type == ACCORDION
  end

  def renders_as_leaf?
    rendering_type == LEAF
  end

  def renders_as_grid?
    rendering_type == GRID
  end

  def accordion_content
    return [] unless renders_as_accordion?
    accordion_items = taxon.child_taxons.map { |taxon| TaxonPresenter.new(taxon) }

    general_information_title = 'General information and guidance'

    if tagged_content.count > 0
      general_information = Taxon.new(
        ContentItem.new(
          'content_id' => taxon.content_id,
          'title' => general_information_title,
          'base_path' => general_information_title.downcase.tr(' ', '-'),
          'description' => ''
        )
      )
      general_information.can_subscribe = false

      accordion_items.unshift(
        TaxonPresenter.new(general_information)
      )
    end

    accordion_items
  end

  def options_for_leaf_content(index:)
    {
      module: 'track-click',
      track_category: 'navLeafLinkClicked',
      track_action: (index + 1).to_s,
      track_label: tagged_content[index].base_path,
      track_options: { dimension28: tagged_content.size.to_s,
                       dimension29: tagged_content[index].title }
    }
  end

  def options_for_child_taxon(index:)
    {
      module: 'track-click',
      track_category: 'navGridContentClicked',
      track_action: (index + 1).to_s,
      track_label: child_taxons[index].base_path,
      track_options: { dimension26: tagged_content.any? ? '2' : '1',
                       dimension27: (child_taxons.length + tagged_content.length).to_s,
                       dimension28: child_taxons.size.to_s,
                       dimension29: child_taxons[index].title }
    }
  end

  def options_for_tagged_content(index:)
    {
      module: 'track-click',
      track_category: 'navGridContentClicked',
      track_action: "L#{index + 1}",
      track_label: tagged_content[index].base_path,
      track_options: { dimension26: '2',
                       dimension27: (child_taxons.length + tagged_content.length).to_s,
                       dimension28: tagged_content.size.to_s,
                       dimension29: tagged_content[index].title }
    }
  end

  def options_for_accordion_content(index:, section_index:)
    {
      module: 'track-click',
      track_category: 'navAccordionLinkClicked',
      track_action: "#{section_index + 1}.#{index + 1}",
      track_label: tagged_content[index].base_path,
      track_options: { dimension28: tagged_content.size.to_s,
                       dimension29: tagged_content[index].title }
    }
  end
end
