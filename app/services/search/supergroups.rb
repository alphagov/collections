module Search
  class Supergroups
    SUPERGROUP_TYPES = %w(
      services
      guidance_and_regulation
      news_and_communications
      research_and_statistics
      policy_and_engagement
      transparency
    ).freeze

    def initialize(organisation:)
      @organisation = organisation
    end

    def has_groups?
      groups.find(&:has_documents?).present?
    end

    def groups
      @groups ||= SUPERGROUP_TYPES.map { |group|
        Supergroup.new(
          organisation_slug: (@organisation ? @organisation.slug : nil),
          content_purpose_supergroup: group
        )
      }
    end
  end
end
