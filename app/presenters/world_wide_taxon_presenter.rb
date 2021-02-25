class WorldWideTaxonPresenter
  ACCORDION = :accordion
  LEAF = :leaf

  attr_reader :taxon
  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :tagged_content,
    :child_taxons,
    :live_taxon?,
    to: :taxon,
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def rendering_type
    taxon.children? ? ACCORDION : LEAF
  end

  def renders_as_accordion?
    rendering_type == ACCORDION
  end

  GENERAL_INFORMATION_TITLE = "General information and guidance".freeze

  def accordion_content
    return [] unless renders_as_accordion?

    accordion_items = ordered_child_taxons.map { |taxon| WorldWideTaxonPresenter.new(taxon) }

    if tagged_content.any?
      general_information = WorldWideTaxon.new(
        ContentItem.new(
          "content_id" => taxon.content_id,
          "title" => GENERAL_INFORMATION_TITLE,
          "base_path" => GENERAL_INFORMATION_TITLE.downcase.tr(" ", "-"),
          "description" => "",
        ),
      )

      accordion_items.unshift(
        WorldWideTaxonPresenter.new(general_information),
      )
    end

    accordion_items
  end

  def options_for_leaf_content(index:)
    {
      module: "gem-track-click",
      track_category: "navLeafLinkClicked",
      track_action: (index + 1).to_s,
      track_label: tagged_content[index].base_path,
      track_options: { dimension28: tagged_content.size.to_s,
                       dimension29: tagged_content[index].title },
    }
  end

  def options_for_accordion_content(index:, section_index:)
    {
      module: "gem-track-click",
      track_category: "navAccordionLinkClicked",
      track_action: "#{section_index + 1}.#{index + 1}",
      track_label: tagged_content[index].base_path,
      track_options: { dimension28: tagged_content.size.to_s,
                       dimension29: tagged_content[index].title },
    }
  end

private

  def ordered_child_taxons
    WorldTaxonomySorter.call(taxon.child_taxons)
  end
end
