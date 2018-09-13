class TaxonPresenter
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

  def sections
    SupergroupSections.supergroup_sections(taxon.content_id, taxon.base_path).unshift(popular_content_section)
  end

  def popular_content_section
    {
      title: "Most popular",
      show_section: true,
      partial_template: "taxons/sections/most_popular",
      documents: popular_content,
      child_topics: show_subtopic_grid?
    }
  end

  def popular_content
    popular_content = MostPopularContent.fetch(content_id: taxon.content_id, filter_content_purpose_supergroup: false)
    associated_taxons = []

    popular_content = popular_content.map do |document|
      {
        title: document.title,
        base_path: document.base_path
      }
    end

    popular_content.each do |document|
      associated_taxons << associated_taxons(document[:base_path])
    end

    {
      popular_content: popular_content,
      associated_taxons: associated_taxons.flatten.uniq
    }
  end

  def associated_taxons(base_path)
    associated_taxons = Services.content_store.content_item(base_path).dig('links', 'taxons')

    associated_taxons = associated_taxons.map do |taxon|
      {
        title: taxon["title"],
        base_path: taxon["base_path"]
      } unless taxon["base_path"].start_with?("/world")
    end

    associated_taxons.compact
  end

  def organisations_section
    @organisations_section ||= TaxonOrganisationsPresenter.new(organisations)
  end

  def show_subtopic_grid?
    child_taxons.count.positive?
  end

  def taxon_page_navigation
    navigation_links = sections.map do |section|
      {
        text: section[:title],
        href: "#" + section[:title].parameterize
      } if section[:show_section]
    end

    navigation_links << {
      text: I18n.t('taxons.organisations'),
      href: "#organisations"
    } if organisations_section.show_organisations?

    navigation_links << {
      text: I18n.t('taxons.all_subtopics'),
      href: "#all-topics"
    } if show_subtopic_grid?

    navigation_links.compact
  end

  def options_for_child_taxon(index:)
    {
      module: 'track-click',
      track_category: 'navGridContentClicked',
      track_action: (index + 1).to_s,
      track_label: child_taxons[index].base_path,
      track_options: {},
    }
  end
end
