class FilterTaggedContent
  def valid?(document)
    return valid_document_collection?(document) if document.document_collection?

    valid_content_item?(document)
  end

private

  def valid_document_collection?(document)
    return true unless all_document_collections.include?(document.base_path)

    valid_document_collections.include?(document.base_path)
  end

  def valid_content_item?(document)
    return true unless document.tagged_to_document_collection?

    document.document_collections.all? do |document_collection|
      valid_content_items_in_document_collections.include?(
        document_collection['link']
      )
    end
  end

  def valid_document_collections
    guidance_document_collections.reduce([]) do |list, document_collection|
      if document_collection['surface_collection']
        list << document_collection['base_path']
      end

      list
    end
  end

  def all_document_collections
    guidance_document_collections.map do |document_collection|
      document_collection['base_path']
    end
  end

  def valid_content_items_in_document_collections
    guidance_document_collections.reduce([]) do |list, document_collection|
      if document_collection['surface_content']
        list << document_collection['base_path']
      end

      list
    end
  end

  def guidance_document_collections
    @guidance_document_collections ||= JSON.parse(
      File.read(
        Rails.root.join(
          "config",
          "guidance_document_collections.json"
        )
      )
    )
  end
end
