class OrganisationsController < ApplicationController
  def index
    @content_item = ContentItem.find!("/government/organisations").to_hash
  end
end
