require 'active_model'

class Document
  include ActiveModel::Model

  attr_accessor(
    :title,
    :description,
    :base_path,
    :public_updated_at,
    :change_note,
    :format,
    :document_collections,
    :content_store_document_type
  )

  def document_collection?
    content_store_document_type == 'document_collection'
  end

  def tagged_to_document_collection?
    document_collections.present?
  end
end
