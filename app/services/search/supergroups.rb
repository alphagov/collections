module Search
  class Supergroups
    CONTENT_PURPOSE_SUPERGROUPS = %w[
      services
      guidance_and_regulation
      news_and_communications
      research_and_statistics
      policy_and_engagement
      transparency
    ].freeze

    def initialize(organisation_slug:)
      @organisation_slug = organisation_slug
    end

    def has_groups?
      groups.find(&:has_documents?).present?
    end

    def groups
      @groups ||= CONTENT_PURPOSE_SUPERGROUPS.map do |group|
        Supergroup.new(
          organisation_slug: @organisation_slug,
          content_purpose_supergroup: group,
        )
      end
    end
  end
end
