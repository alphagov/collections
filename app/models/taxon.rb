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

  def tagged_content
    @tagged_content ||= fetch_tagged_content
  end

  def self.find(base_path)
    content_item = ContentItem.find!(base_path)
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

  def associated_taxons
    linked_items('associated_taxons').map do |associated_taxon|
      self.class.new(associated_taxon)
    end
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

private

  def fetch_tagged_content
    taxon_content_ids = [content_id] + associated_taxons.map(&:content_id)
    TaggedContent.fetch(
      taxon_content_ids,
      filter_by_document_supertype: 'guidance',
      validate: true
    )
  end
end
