module SupergroupSections
  # These should remain in order as the sequence of sections displayed on the
  # page is important.
  SUPERGROUPS = [
    Service.new,
    GuidanceAndRegulations.new,
    NewsAndCommunications.new,
    PolicyAndEngagement.new,
    Transparency.new
  ].freeze

  def self.supergroup_sections(taxon_id, base_path)
    supergroups = Sections.new(taxon_id, base_path)
    supergroups.sections
  end

  class Sections
    attr_reader :taxon_id, :base_path

    def initialize(taxon_id, base_path)
      @taxon_id = taxon_id
      @base_path = base_path
    end

    def sections
      SupergroupSections::SUPERGROUPS.map do |supergroup|
        {
          title: supergroup.title,
          documents: section_document_list(supergroup),
          see_more_link: section_finder_link(supergroup.name),
          show_section: show_section?(supergroup)
        }
      end
    end

    def section_document_list(supergroup)
      supergroup.tagged_content(taxon_id).each.map do |document|
        data = {
          link: {
            text: document.title,
            path: document.base_path
          },
          metadata: {
            public_updated_at: document.public_updated_at,
            organisations: document.organisations,
            document_type: document.content_store_document_type.humanize
          }
        }

        data[:link][:description] = document.description if add_description?(supergroup, document)
        data.delete(:metadata) if services?(supergroup)
        data[:metadata].except!(:public_updated_at, :organisations) if guide?(document)

        data
      end
    end

    def add_description?(supergroup, document)
      services?(supergroup) || guide?(document)
    end

    def services?(supergroup)
      supergroup.name == 'services'
    end

    def guide?(document)
      document.content_store_document_type == 'guide'
    end

    def show_section?(supergroup)
      supergroup.content.any?
    end

    def section_finder_link(supergroup_name)
      link_text = supergroup_name.humanize(capitalize: false)

      query_string = {
        topic: base_path,
        group: supergroup_name
      }.to_query

      {
        text: "See all #{link_text}",
        url: "/search/advanced?#{query_string}"
      }
    end
  end
end
