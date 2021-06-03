class OrganisationsFacetPresenter
  attr_reader :title, :web_url

  include ActionView::Helpers::UrlHelper

  def initialize(facet_information)
    @organisations = facet_information["options"].map do |option|
      value = option["value"]
      [value["title"], value["link"]]
    end
  end

  def any?
    @organisations.any?
  end

  def array_of_links
    @organisations.map do |title, link|
      link_to title, link
    end
  end
end
