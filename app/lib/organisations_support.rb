# this is for an organisations_homepage content item, so will not work with an organisation content item
module OrganisationsSupport
  def joining?(organisation)
    return false if organisation.nil?

    organisation["govuk_status"] == "joining"
  end

  def reject_joining_organisations(organisations)
    organisations.reject { |organisation| joining?(organisation) }
  end

  def works_with_categorised_links(organisation)
    organisation.fetch("works_with", {})
  end

  def reject_empty_link_categories(categorised_links)
    categorised_links.reject { |_category, links| links.empty? }
  end

  def reject_joining_links(links, organisation_map)
    links.reject do |link|
      joining?(organisation_map[link["href"]])
    end
  end

  def reject_joining_categorised_links(categorised_links, organisation_map)
    non_joining_categorised_links = categorised_links.transform_values do |links|
      reject_joining_links(links, organisation_map)
    end
    reject_empty_link_categories(non_joining_categorised_links)
  end

  def non_joining_works_with_categorised_links(organisation, organisation_map)
    reject_joining_categorised_links(works_with_categorised_links(organisation), organisation_map)
  end

  def non_joining_works_with_links_count(organisation, organisation_map)
    non_joining_works_with_categorised_links(organisation, organisation_map).values.flatten.count
  end
end
