module CitizenReadiness
  class LinkPresenter
    include Tracking

    attr_reader :base_path

    def initialize(base_path, index)
      @base_path = base_path
      @index = index #used in link tracking
    end

    def title
      I18n.t("campaign.links.#{slug}.title")
    end

    def description
      I18n.t("campaign.links.#{slug}.description")
    end

    def link
      base_path
    end

  private

    def slug
      link.delete("/")
    end
  end
end
