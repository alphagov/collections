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
      taxons: popular_taxon_content,
      child_topics: show_subtopic_grid?
    }
  end

  def popular_taxons
    popular_content = MostPopularContent.fetch(content_id: taxon.content_id, filter_content_purpose_supergroup: false)
    popular_taxons = []

    popular_content.each do |document|
      popular_taxons << Services.content_store.content_item(document.base_path).dig('links', 'taxons').map do |taxon|
        {
          content_id: taxon["content_id"],
          title: taxon["title"],
          base_path: taxon["base_path"]
        } unless taxon["base_path"].start_with?("/world")
      end
    end

    popular_taxons.flatten.compact.uniq
  end

  def popular_taxon_content
    popular_taxon_content = []

    popular_taxons[0..2].each do |taxon|
      popular_taxon_content << {
        title: taxon[:title],
        base_path: taxon[:base_path],
        parent: taxon[:base_path].split("/")[1].humanize.gsub("-", " "),
        popular_content: MostPopularContent.fetch(content_id: taxon[:content_id], filter_content_purpose_supergroup: false).map do |document|
          {
            title: document.title,
            base_path: document.base_path
          }
        end
      }
      end

    popular_taxon_content.group_by{|row| row[:title]}
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
