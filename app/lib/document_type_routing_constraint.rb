class DocumentTypeRoutingConstraint
  def initialize(document_type, document_type_inspector: DocumentTypeInspector)
    @document_type = document_type
    @document_type_inspector = document_type_inspector
  end

  def matches?(request)
    @request = request
    document_type == @document_type
  end

private

  def document_type
    @request.env[:__document_type] ||= begin
      document_type_inspector.document_type || set_error(document_type_inspector.error) || :no_match
    end
  end

  def set_error(err)
    @request.env[:__api_error] = err
    false
  end

  def document_type_inspector
    @request.env[:__inspector] ||= @document_type_inspector.new(slug)
  end

  def slug
    @request.params.fetch(:slug)
  end
end
