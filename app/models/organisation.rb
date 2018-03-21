require 'active_model'

class Organisation
  include ActiveModel::Model

  attr_accessor(
    :title,
    :content_id,
    :link,
    :slug,
    :organisation_state,
    :document_count
  )

  def live?
    organisation_state == 'live'
  end
end
