class Taxon
  attr_reader :content_item

  delegate(
    :content_id,
    :base_path,
    :title,
    :description,
    :linked_items,
    :to_hash,
    :phase,
    :details,
    to: :content_item,
  )

  class InAlphaPhase < StandardError
  end

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find(base_path)
    content_item = ContentItem.find!(base_path)

    unless content_item.document_type == "taxon"
      raise "Tried to render a taxon page for content item that is not a taxon"
    end

    if content_item.phase == "alpha"
      # Ignore alpha taxons, as they shouldn't be shown
      raise InAlphaPhase
    end

    new(content_item)
  end

  def child_taxons
    @child_taxons ||= begin
      return [] unless children?

      linked_items("child_taxons")
        .map { |child_taxon| self.class.new(child_taxon) }
        .reject(&:alpha_taxon?)
    end
  end

  def children?
    linked_items("child_taxons").present?
  end

  def parent_taxons
    @parent_taxons ||= begin
      return [] unless parents?

      linked_items("parent_taxons")
          .map { |child_taxon| self.class.new(child_taxon) }
          .reject(&:alpha_taxon?)
    end
  end

  def parents?
    linked_items("parent_taxons").present?
  end

  def merge(to_merge)
    Taxon.new(content_item.merge(to_merge))
  end

  def live_taxon?
    phase == "live"
  end

  def alpha_taxon?
    phase == "alpha"
  end

  def organisations
    @organisations ||= TaggedOrganisations.fetch(content_id)
  end

  def translations
    linked_items("available_translations")
  end

  def preferred_url
    details["url_override"].presence || base_path
  end
end
