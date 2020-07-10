class DocumentTypeInspector
  include ActiveSupport::Rescuable

  attr_reader :error

  def initialize(slug)
    @slug = slug
  end

  def document_type
    content_item["document_type"]
  end

private

  attr_reader :slug

  def handle_api_errors
    yield
  rescue GdsApi::HTTPErrorResponse,
         GdsApi::InvalidUrl => e
    @error = e
    {}
  end

  def content_item
    return {} if error?

    @content_item ||= handle_api_errors do
      content_store.content_item("/#{slug}")
    end
  end

  def error?
    @error.present?
  end

  def content_store
    @content_store ||= Services.content_store
  end
end
