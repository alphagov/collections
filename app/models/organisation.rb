require 'active_model'

class Organisation
  include ActiveModel::Model

  attr_accessor(
    :title,
    :content_id,
    :link,
    :slug,
    :organisation_state,
    :document_count,
    :logo_formatted_title,
    :brand,
    :crest,
    :logo_url
  )

  def live?
    organisation_state == 'live'
  end

  def has_logo?
    [
      logo_formatted_title,
      brand,
      crest
    ].none?(&:blank?)
  end

  def custom_logo?
    crest == 'custom'
  end
end
