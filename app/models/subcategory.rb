class Subcategory
  def self.find(slug, api_options = {})
    collections_api = Collections.services(:collections_api)

    if (collections_api_response = collections_api.topic("/#{slug}", filtered_api_options(api_options)))
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

  def documents_total
    details.documents_total
  end

  def documents_start
    details.documents_start
  end

private

  attr_reader :data

  def details
    data.details
  end

  def self.filtered_api_options(options)
    options.slice(:start, :count).reject {|_,v| v.blank? }
  end
end
