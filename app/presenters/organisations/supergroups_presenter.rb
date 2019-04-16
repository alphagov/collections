module Organisations
  class SupergroupsPresenter
    include OrganisationHelper
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def has_groups?
      supergroups_collection.has_groups?
    end

    def latest_documents_by_supergroup
      supergroups_collection.groups.map { |supergroup|
        next unless supergroup.has_documents?

        {
          documents: search_results_to_documents(supergroup.documents, @org),
          title: I18n.t(:title, scope: [:organisations, :document_types, supergroup.content_purpose_supergroup]),
          finder_link: finder_link(supergroup)
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
      }
    end

    def supergroups_collection
      @supergroups_collection ||= Search::Supergroups.new(organisation: @org)
    end
  end
end
