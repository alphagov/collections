module Supergroups
  class Supergroup
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def title
      name.humanize
    end

    def finder_link(base_path, taxon_id)
      {
        text: see_all_link_text,
        url: finder_url(base_path, taxon_id),
        data: see_all_link_data_attributes(base_path, name),
      }
    end

    def show_section?(taxon_id)
      tagged_content(taxon_id).any?
    end

    def partial_template
      "taxons/sections/#{name}"
    end

    def tagged_content(_taxon_id)
      raise NotImplementedError
    end

    def document_list(taxon_id)
      items = tagged_content(taxon_id)

      format_document_data(items)
    end

    def data_module_label
      name.camelize(:lower)
    end

  private

    def finder_path
      "/search/#{name.dasherize}"
    end

    def finder_url(base_path, taxon_id)
      query_string = { parent: base_path, topic: taxon_id }.to_query
      [finder_path, query_string].join("?")
    end

    def see_all_link_text
      group_title = I18n.t(name, scope: :content_purpose_supergroup, default: title)

      I18n.t(:see_all_in_topic, scope: :taxons, type: group_title.downcase)
    end

    def see_all_link_data_attributes(base_path, name)
      {
        track_category: "SeeAllLinkClicked",
        track_action: base_path,
        track_label: name,
        module: "gem-track-click",
      }
    end

    def data_attributes(base_path, link_text, index)
      {
        module: "gem-track-click",
        track_category: "#{data_module_label}DocumentListClicked",
        track_action: index,
        track_label: base_path,
        track_options: {
          dimension29: link_text,
        },
      }
    end

    def format_document_data(documents, data_category: "", with_image_url: false)
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document.title,
            path: document.base_path,
            data_attributes: data_attributes(document.base_path, document.title, index),
          },
          metadata: {
            public_updated_at: document.public_updated_at,
            organisations: document.organisations,
            document_type: document.content_store_document_type.humanize,
          },
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
      # this image has been uploaded to asset-manager
      "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg"
    end

    def document_types
      GovukDocumentTypes.supergroup_document_types(name)
    end
  end
end
