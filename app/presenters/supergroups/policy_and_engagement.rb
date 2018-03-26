module Supergroups
  class PolicyAndEngagement < Supergroup
    attr_reader :content

    def initialize
      super('policy_and_engagement')
    end

    def tagged_content(taxon_id)
      @content = MostRecentContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: @name)
    end
  end
end
