# this is for an organisations_homepage content item, so will not work with an organisation content item
module OrganisationsHelper
  def child_organisations_count(organisation)
    organisation["works_with"].values.flatten.count
  end
end
