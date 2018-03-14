class TaxonPresenter
  attr_reader :taxon
  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :tagged_content,
    :child_taxons,
    :live_taxon?,
    :guidance_and_regulation_content,
    :services_content,
    to: :taxon
  )
  def initialize(taxon)
    @taxon = taxon
  end

  def guidance_and_regulation_list
    guidance_and_regulation_content.each.map do |link|
      {
        link: {
          text: link.title,
          path: link.base_path
        },
        metadata: {
          public_updated_at: link.public_updated_at,
          document_type: link.content_store_document_type.humanize
        },
      }
    end
  end

  def show_guidance_section?
    guidance_and_regulation_content.count.positive?
  end

  def options_for_child_taxon(index:)
    {
      module: 'track-click',
      track_category: 'navGridContentClicked',
      track_action: (index + 1).to_s,
      track_label: child_taxons[index].base_path,
      track_options: { dimension26: tagged_content.any? ? '2' : '1',
                       dimension27: (child_taxons.length + tagged_content.length).to_s,
                       dimension28: child_taxons.size.to_s,
                       dimension29: child_taxons[index].title }
    }
  end
end
