class BrexitCitizenPresenter
  attr_reader :taxon, :content
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
    @content ||= Supergroups::BrexitForCitizens.new.document_list(taxon.content_id)
  end
end
