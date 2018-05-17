module OrganisationHelper
  def child_organisations_count(organisation)
    organisation["works_with"].values.flatten.count
  end
end
