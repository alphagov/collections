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
      query_string = {
        topic: base_path,
        group: name
      }.to_query

      {
        text: see_all_link_text,
        url: "/search/advanced?#{query_string}",
        data: see_all_link_data_attributes(base_path)
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
      items = tagged_content(taxon_id)

      format_document_data(items)
    end

    def data_module_label
      name.camelize(:lower)
    end

  private

    def see_all_link_text
      group_title = I18n.t(name, scope: :content_purpose_supergroup, default: title)

      I18n.t(:see_all_in_topic, scope: :taxons, type: group_title.downcase)
    end

    def see_all_link_data_attributes(base_path)
      {
        track_category: "SeeAllLinkClicked",
        track_action: base_path,
        track_label: name,
        module: "track-click"
      }
    end

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

    def format_document_data(documents, data_category = "", with_image_url = false)
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

        if with_image_url
          data[:image] = { url: (document.image_url || default_news_image_url) }
        end

        data
      end
    end

    def default_news_image_url
      "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg"
    end

    def document_types
      GovukDocumentTypes.supergroup_document_types(name)
    end
  end
end
