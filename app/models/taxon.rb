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
    to: :content_item
  )

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find(base_path)
    content_item = ContentItem.find!(base_path)

    unless content_item.document_type == "taxon"
      raise "Tried to render a taxon page for content item that is not a taxon"
    end

    new(content_item)
  end

  def child_taxons
    return [] unless children?

    linked_items('child_taxons').map do |child_taxon|
      self.class.new(child_taxon)
    end
  end

  def children?
    linked_items('child_taxons').present?
  end

  def parent_taxons
    return [] unless parents?

    linked_items('parent_taxons').map do |parent_taxon|
      self.class.new(parent_taxon)
    end
  end

  def parents?
    linked_items('parent_taxons').present?
  end

  def merge(to_merge)
    Taxon.new(content_item.merge(to_merge))
  end

  def live_taxon?
    phase == "live"
  end

  def organisations
    @organisations ||= TaggedOrganisations.fetch(content_id)
  end
end
