class Subcategory
  def self.find(slug)
    collections_api = Collections.services(:collections_api)

    if (collections_api_response = collections_api.topic("/#{slug}"))
      new(slug, collections_api_response)
    else
      nil
    end
  end

  def initialize(slug, data)
    @slug = slug
    @data = data
  end

  attr_reader :slug

  def groups
    details.groups
  end

  def changed_documents
    details.documents
  end

  def description
    data.description
  end

  def parent_sector
    data.parent
  end

  def parent_sector_title
    parent_sector.title
  end

  def title
    data.title
  end

  def combined_title
    "#{parent_sector_title}: #{title}"
  end

private

  attr_reader :data

  def details
    data.details
  end
end
