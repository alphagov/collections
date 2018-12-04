class BrexitForCitizensPresenter
  attr_reader :taxon
  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :child_taxons,
    :live_taxon?,
    :section_content,
    :organisations,
    to: :taxon
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def content
    @content ||= brexit_for_citizen_documents.map do |doc|
      doc[:path] = "https://www.gov.uk#{doc[:path]}"
      doc
    end
  end

private

  def brexit_for_citizen_documents
    supergroup = Supergroups::BrexitForCitizens.new
    supergroup.document_list(taxon.content_id)
  end
end
