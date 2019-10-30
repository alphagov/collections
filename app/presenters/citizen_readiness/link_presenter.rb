module CitizenReadiness
  class LinkPresenter
    include Tracking

    attr_reader :base_path

    def initialize(base_path)
      @base_path = base_path
    end

    def title
      I18n.t("brexit_campaign.links.#{slug}.title")
    end

    def description
      I18n.t("brexit_campaign.links.#{slug}.description")
    end

    def link
      base_path
    end

  private

    def slug
      link.parameterize
    end
  end
end
