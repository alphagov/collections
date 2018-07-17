module Feeds
  class OrganisationFeedEntryPresenter
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
      Time.zone.parse(result["public_timestamp"])
    end

    def title
      if display_type.present?
        "#{display_type}: #{result['title']}"
      else
        result['title']
      end
    end

    def description
      result["description"]
    end

    def display_type
      result["display_type"]
    end
  end
end
