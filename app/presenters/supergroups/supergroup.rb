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
      items = tagged_content(taxon_id).drop(promoted_content_count)

      format_document_data(items)
    end

    def promoted_content(*)
      []
    end

    def data_module_label
      name.camelize(:lower)
    end

  private

    def data_attributes(base_path, link_text, index)
      {
        track_category: data_module_label + "DocumentListClicked",
        track_action: index,
        track_label: base_path,
        track_options: {
          dimension29: link_text
        }
      }
    end

    def promoted_content_count(*)
      2
    end

    def format_document_data(documents, data_category = "")
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            data_attributes: data_attributes(document.base_path, document.title, index)
          },
          metadata: {
            public_updated_at: document.public_updated_at,
            organisations: document.organisations,
            document_type: document.content_store_document_type.humanize
          }
        }

        if data_category.present?
          data[:link][:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end
  end
end
