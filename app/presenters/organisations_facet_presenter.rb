class OrganisationsFacetPresenter
  attr_reader :title, :web_url
  include ActionView::Helpers::UrlHelper

  def initialize(facet_information)
    @organisations = facet_information["options"].map { |option|
      value = option["value"]
      [value["title"], value["link"]]
    }
  end

  def any?
    @organisations.any?
  end

  def array_of_links
    @organisations.map { |title, link|
      link_to title, link, class: 'organisation-link'
    }
  end
end
