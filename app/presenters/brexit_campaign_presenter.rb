class BrexitCampaignPresenter
  attr_reader :taxon
  delegate(
    :title,
    :base_path,
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

  def description
    I18n.t("campaign.taxon_descriptions.#{taxon.base_path.gsub("/", "")}")
  end

  def finder_link
    "/prepare-eu-exit-live-uk#{ taxon.base_path }"
  end

private

  def brexit_for_citizen_documents
    supergroup = Supergroups::BrexitForCitizens.new
    supergroup.document_list(taxon.content_id)
  end
end
