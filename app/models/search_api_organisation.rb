require "active_model"

class SearchApiOrganisation
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
    :logo_url,
  )

  def live?
    organisation_state == "live"
  end

  def has_logo?
    crest.present? && crest != "no-identity" && !custom_logo?
  end

  def custom_logo?
    crest == "custom" && logo_url.present?
  end
end
