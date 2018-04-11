module Supergroups
  class Supergroup
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def title
      name.humanize
    end

    def finder_link(base_path)
      link_text = title.downcase

      query_string = {
        topic: base_path,
        group: name
      }.to_query

      {
        text: "See all #{link_text}",
        url: "/search/advanced?#{query_string}"
      }
    end

    def show_section?(taxon_id)
      tagged_content(taxon_id).any?
    end

    def partial_template
      "taxons/sections/#{name}"
    end

    def tagged_content(_taxon_id)
      raise NotImplementedError.new
    end

    def document_list(taxon_id)
      tagged_content(taxon_id).each.map do |document|
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

        data
      end
    end
  end
end
