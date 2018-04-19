class PolicyAreasController < ApplicationController
  def index
    @content_item = {}
    @policy_areas = Services.rummager.search(count: 1000, filter_format: 'topic')['results']
  end

  def show
    render 'show', locals: {
      policy_area: policy_area
    }
  end

private

  def policy_area
    organisation = ContentItem.find!("/government/topics/" + request.path.split('/').last)
    @policy_area ||= TopicalEventPresenter.new(organisation)
  end

  class TopicalEventPresenter
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
      SuperGroupsForPolicyAreas.supergroup_sections(slug)
    end

    def organisations
      Services.rummager.search(
        count: 0,
        aggregate_organisations: 1000,
        filter_policy_areas: content_item.base_path.split('/').last,
      ).dig('aggregates', 'organisations', 'options')
    end

    def taxon_organisations
      organisations.map do |organisation|
        puts organisation.inspect
        {
          link: {
            text: organisation["value"]["title"],
            path: organisation["value"]["link"]
          }
        }
      end
    end
  end

  module SuperGroupsForPolicyAreas
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
          supergroup = supergroup_class.new(filter_policy_areas: slug)
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
