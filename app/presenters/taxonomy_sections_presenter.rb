class TaxonomySectionsPresenter
  def initialize
    @content_item = ContentItem.find!("/coronavirus-taxons").to_hash
  end

  def present
    content_item["links"]["child_taxons"].map do |child_taxon|
      {
        "title" => child_taxon["title"],
        "sub_sections" => sub_sections(child_taxon),
      }
    end
  end

private

  attr_reader :content_item

  def sub_sections(child_taxon)
    if should_display_with_sub_sections?(child_taxon)
      child_taxon["links"].fetch("child_taxons", []).map do |grandchild_taxon|
        {
          "title" => grandchild_taxon["title"],
          "list" => ordered_related_items(grandchild_taxon),
        }
      end
    else
      [
        {
          "title" => nil,
          "list" => ordered_related_items(child_taxon),
        },
      ]
    end
  end

  def should_display_with_sub_sections?(child_taxon)
    # TODO: If we want to not show this for some taxa, we'll want to add a new field or add custom logic here
    child_taxon["links"].fetch("child_taxons", []).any?
  end

  def ordered_related_items(taxon)
    taxon["links"].fetch("ordered_related_items", []).map do |item|
      {
        "url" => item["base_path"],
        "label" => item["title"],
      }
    end
  end
end
