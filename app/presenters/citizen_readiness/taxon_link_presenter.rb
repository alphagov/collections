module CitizenReadiness
  class TaxonLinkPresenter
    include Tracking

    attr_reader :taxon_content_item
    delegate(
      :title,
      :base_path,
      to: :taxon_content_item
    )

    def initialize(taxon_content_item)
      @taxon_content_item = taxon_content_item
    end

    def description
      I18n.t("campaign.taxon_descriptions.#{base_path.delete('/')}")
    end

    def link
      "/prepare-eu-exit#{base_path}"
    end
  end
end
