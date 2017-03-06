class DocumentCollectionFetcher
  def self.guidance
    JSON.parse(
      File.read(
        Rails.root.join(
          "config",
          "guidance_document_collections.json"
        )
      )
    )
  end
end
