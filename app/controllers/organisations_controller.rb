class OrganisationsController < ApplicationController
  def index
    @organisations = ContentStoreOrganisation.find!("/government/organisations")
    setup_content_item_and_navigation_helpers(@organisations)
  end
end
