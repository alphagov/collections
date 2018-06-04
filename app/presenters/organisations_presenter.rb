class OrganisationsPresenter
  def initialize(organisations)
    @organisations = organisations
  end

  def title
    @organisations.content_item.title
  end

  def ministerial_departments
    {
      number_10: @organisations.number_10,
      ministerial_departments: @organisations.ministerial_departments
    }
  end
end
