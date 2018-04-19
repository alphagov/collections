class OrganisationsController < ApplicationController
  def index
    @content_item = {}
    @orgs = Services.rummager.search(count: 1000, filter_format: 'organisation')['results']
  end

  def show
    render 'show', locals: {
      presented_organisation: presented_organisation
    }
  end

private

  def presented_organisation
    organisation = ContentItem.find!("/government" + request.path)
    @presented_organisation ||= OrganisationPresenter.new(organisation)
  end

  class OrganisationPresenter
    attr_reader :content_item
    delegate(
      :content_id,
      :title,
      :description,
      :base_path,
      to: :content_item
    )

    def initialize(content_item)
      @content_item = content_item
    end

    def sections
      slug = content_item.base_path.split('/').last
      OrgSuperGroups.supergroup_sections(slug)
    end
  end

  module OrgSuperGroups
    # These should remain in order as the sequence of sections displayed on the
    # page is important.
    SUPERGROUPS = [
      Supergroups::Services,
      Supergroups::GuidanceAndRegulation,
      Supergroups::NewsAndCommunications,
      Supergroups::PolicyAndEngagement,
      Supergroups::Transparency
    ].freeze

    def self.supergroup_sections(slug)
      supergroups = Sections.new(slug)
      supergroups.sections
    end

    class Sections
      attr_reader :slug

      def initialize(slug)
        @slug = slug
      end

      def sections
        SupergroupSections::SUPERGROUPS.map do |supergroup_class|
          supergroup = supergroup_class.new(filter_organisations: slug)
          {
            title: supergroup.title,
            documents: supergroup.document_list,
            partial_template: supergroup.partial_template,
            see_more_link: supergroup.finder_link('/'),
            show_section: supergroup.show_section?
          }
        end
      end
    end
  end
end
