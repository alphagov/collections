class Taxon
  attr_reader :content_item
  attr_accessor :can_subscribe, :tagged_content

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

  def services_content
    @services_content ||= fetch_most_popular_content('services')
  end

  def guidance_and_regulation_content
    @guidance_and_regulation_content ||= fetch_most_popular_content('guidance_and_regulation')
  end

  def most_popular_content
    @most_popular_content ||= fetch_most_popular_content
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

  def parent?
    linked_items('parent_taxons').present?
  end

  def children?
    linked_items('child_taxons').present?
  end

  def grandchildren?
    return false unless children?

    # The Publishing API doesn't expand child taxons, which means
    # we can't use the child_taxons method for each of the child
    # taxons of this taxon. We have to do an API call to know if
    # the children also have children.
    child_taxons.any? do |child_taxon|
      Taxon.find(child_taxon.base_path).children?
    end
  end

  def associated_taxons
    linked_items('associated_taxons').map do |associated_taxon|
      self.class.new(associated_taxon)
    end
  end

  def merge(to_merge)
    Taxon.new(content_item.merge(to_merge))
  end

  def can_subscribe?
    return @can_subscribe if defined?(@can_subscribe)

    true
  end

  def live_taxon?
    phase == "live"
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

  def fetch_most_popular_content(content_purpose_supergroup = 'guidance_and_regulation')
    MostPopularContent.fetch(content_id: content_id, filter_content_purpose_supergroup: content_purpose_supergroup)
  end
end
