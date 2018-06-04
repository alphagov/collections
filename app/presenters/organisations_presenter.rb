class OrganisationsPresenter
  def initialize(organisations)
    @organisations = organisations
  end

  def title
    @organisations.content_item.title
  end
end
