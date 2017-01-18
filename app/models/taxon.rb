class Taxon
  attr_reader :content_item
  delegate(
    :content_id,
    :base_path,
    :title,
    :description,
    :linked_items,
    to: :content_item
  )

  def initialize(content_item)
    @content_item = content_item
  end

  def has_grandchildren?
    return false unless children?

    # The Publishing API doesn't expand child taxons, which means
    # we can't use the child_taxons method for each of the child
    # taxons of this taxon. We have to do an API call to know if
    # the children also have children.
    child_taxons.any? do |child_taxon|
      Taxon.find(child_taxon.base_path).children?
    end
  end

  # TODO: needs to be guidance content only
  def tagged_content
    @tagged_content ||= TaggedContent.fetch(content_id)
  end

  def self.find(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def parent_taxon
    return nil unless parent?

    self.class.new(linked_items('parent_taxons').first)
  end

  def child_taxons
    return [] unless children?

    linked_items('child_taxons').map do |child_taxon|
      self.class.new(child_taxon)
    end
  end

  def parent?
    linked_items('parent_taxons').present?
  end

  def children?
    linked_items('child_taxons').present?
  end
end
