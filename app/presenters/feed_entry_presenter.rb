class FeedEntryPresenter
  attr_reader :result

  def initialize(result)
    @result = result
  end

  def id
    "#{url}##{updated.rfc3339}"
  end

  def url
    Plek.current.website_root + result["link"]
  end

  def atom_url
    "#{url}.atom"
  end

  def updated
    # Collections now uses London time. Convert it back to it's former zone
    # of UTC in the domain of atom feeds to ensure backwards compatibility.

    @utc_time = Time.find_zone("UTC")
    @utc_time.parse(result["public_timestamp"])
  end

  def title
    if display_type.present?
      "#{display_type}: #{result['title']}"
    else
      result["title"]
    end
  end

  def description
    result["description"]
  end

  def display_type
    result["display_type"]
  end
end
