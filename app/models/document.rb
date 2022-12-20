require "active_model"

class Document
  include ActiveModel::Model

  attr_accessor(
    :title,
    :description,
    :base_path,
    :public_updated_at,
    :end_date,
    :change_note,
    :format,
    :content_store_document_type,
    :organisations,
    :image_url,
    :content_id,
  )
end
