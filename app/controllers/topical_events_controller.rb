class TopicalEventsController < ApplicationController
  def index
    @content_item = {}
    @topical_events = Services.rummager.search(count: 1000, filter_format: 'topical_event')['results']
  end

  def show
    render 'show', locals: {
      topical_event: topical_event
    }
  end

private

  def topical_event
    organisation = ContentItem.find!("/government" + request.path)
    @topical_event ||= TopicalEventPresenter.new(organisation)
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
      SuperGroupsForTopicalEvents.supergroup_sections(slug)
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

  module SuperGroupsForTopicalEvents
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
