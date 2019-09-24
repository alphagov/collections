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

    SUPERGROUP_ADDITIONAL_SEARCH_PARAMS = {
      "guidance_and_regulation" => {
        order: "-popularity",
      },
      "news_and_communications" => {
        reject_content_purpose_subgroup: %w[decisions updates_and_alerts],
      },
      "services" => {
        order: "-popularity",
      },
    }.freeze

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
          content_purpose_supergroup: group,
          additional_search_params: SUPERGROUP_ADDITIONAL_SEARCH_PARAMS.fetch(group, {}),
        )
      }
    end
  end
end
