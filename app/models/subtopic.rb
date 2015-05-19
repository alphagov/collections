class Subtopic
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
    # FIXME: remove this temporary hack when we have a way to add
    # manuals (and other content-store content) to a subtopic
    if @slug == "farming-food-grants-payments/rural-grants-payments"
      groups = details.groups.map do |group|
        if group.name == "Rural development"
          group.contents.unshift(
            OpenStruct.new({
              :title => "Countryside Stewardship",
              :web_url => "#{Plek.new.website_root}/guidance/countryside-stewardship",
            })
          )
        end
        group
      end
    else
      details.groups
    end
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

  def parent_slug
    split_slug[0]
  end

  def child_slug
    split_slug[1]
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

  def split_slug
    slug.split('/')
  end

  def self.filtered_api_options(options)
    options.slice(:start, :count).reject {|_,v| v.blank? }
  end
end
