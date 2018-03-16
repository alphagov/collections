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

  def sections
    supergroups = %w(guidance_and_regulation)

    supergroups.map do |supergroup|
      {
        show_section: show_section?(supergroup),
        title: section_title(supergroup),
        documents: section_document_list(supergroup)
      }
    end
  end

  def section_title(supergroup)
    supergroup.humanize
  end

  def section_document_list(supergroup)
    section_content(supergroup).each.map do |document|
      {
        link: {
          text: document.title,
          path: document.base_path
        },
        metadata: {
          public_updated_at: document.public_updated_at,
          document_type: document.content_store_document_type.humanize
        },
      }
    end
  end

  def show_section?(supergroup)
    section_content(supergroup).any?
  end

  def section_content(supergroup)
    method(supergroup + "_content").call
  end

  def show_subtopic_grid?
    child_taxons.count.positive?
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
