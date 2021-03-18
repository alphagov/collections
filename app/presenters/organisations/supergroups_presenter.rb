module Organisations
  class SupergroupsPresenter
    include OrganisationHelper
    include ApplicationHelper
    attr_reader :org

    DEFAULT_EXCLUDE_METADATA_FOR = %w[services].freeze

    attr_accessor :exclude_metadata_for

    def initialize(organisation, exclude_metadata_for: DEFAULT_EXCLUDE_METADATA_FOR)
      @org = organisation
      @exclude_metadata_for = exclude_metadata_for
    end

    delegate :has_groups?, to: :supergroups_collection

    def latest_documents_by_supergroup
      supergroups_collection.groups.map { |supergroup|
        next unless supergroup.has_documents?

        exclude_metadata = exclude_metadata_for.include? supergroup.content_purpose_supergroup

        {
          documents: search_results_to_documents(supergroup.documents, @org, include_metadata: !exclude_metadata),
          title: I18n.t(:title, scope: [:organisations, :document_types, supergroup.content_purpose_supergroup]),
          lang: t_fallback("organisations.document_types.#{supergroup.content_purpose_supergroup}.title"),
          finder_link: finder_link(supergroup),
        }
      }.compact
    end

  private

    def finder_link(supergroup)
      document_type = supergroup.content_purpose_supergroup

      {
        text: I18n.t(
          :text,
          organisation: @org.slug,
          scope: [:organisations, :document_types, document_type, :see_all],
        ),
        path: I18n.t(
          :path,
          organisation: @org.slug,
          scope: [:organisations, :document_types, document_type, :see_all],
        ),
        lang: t_lang("organisations.document_types.#{supergroup.content_purpose_supergroup}.see_all.text"),
      }
    end

    def supergroups_collection
      @supergroups_collection ||= Search::Supergroups.new(organisation_slug: @org.slug)
    end
  end
end
