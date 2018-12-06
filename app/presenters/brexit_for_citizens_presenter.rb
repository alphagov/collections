class BrexitForCitizensPresenter
  FEATURED_TAXONS_DESCRIPTIONS = {
    "/health-and-social-care" => "Includes health insurance and healthcare in the EU.",
    "/transport" => "Includes driving licences, flying to the EU.",
    "/environment" => "Includes environmental standards.",
    "/business-and-industry" => "Includes consumer rights and banking.",
    "/education" => "Includes studying abroad and Erasmus+.",
    "/going-and-being-abroad" => "Includes passports, pet travel and mobile roaming fees."
  }.freeze

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

  def description(title)
    desc_lookup = {
      "Going and being abroad" => "Includes passports, pet travel and mobile roaming fees.",
      "Health and social care" => "Includes health insurance and healthcare in the EU.",
      "Transport" => "Includes driving licences, flying to the EU.",
      "Environment" => "Includes environmental standards.",
      "Business and industry" => "Includes consumer rights and banking.",
      "Education, training and skills" => "Includes studying abroad and Erasmus+."
    }

    desc_lookup[title]
  end

  def content
    @content ||= brexit_for_citizen_documents.map do |doc|
      doc[:path] = "https://www.gov.uk#{doc[:path]}"
      doc[:main_description] = ""
      doc
    end
  end

  def description
    FEATURED_TAXONS_DESCRIPTIONS.fetch(@taxon.base_path, "")
  end

private

  def brexit_for_citizen_documents
    supergroup = Supergroups::BrexitForCitizens.new
    supergroup.document_list(taxon.content_id)
  end
end
