class DocumentTypeRoutingConstraint
  def initialize(document_type)
    @document_type = document_type
  end

  def matches?(request)
    @request = request
    request_document_type == @document_type
  end

private

  def request_document_type
    @request.env[:__document_type] ||= document_type_inspector.document_type || set_error(document_type_inspector.error) || :no_match
  end

  def set_error(err)
    @request.env[:__api_error] = err
    false
  end

  def document_type_inspector
    @request.env[:__inspector] ||= DocumentTypeInspector.new(slug)
  end

  def slug
    @request.params.fetch(:slug)
  end
end
