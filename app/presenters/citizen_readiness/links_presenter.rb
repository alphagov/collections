module CitizenReadiness
  class LinksPresenter
    CITIZEN_TAXON_CONTENT_ID = 'd7bdaee2-8ea5-460e-b00d-6e9382eb6b61'.freeze

    FEATURED_LINKS = %w(
      /visit-europe-brexit
      /buying-europe-brexit
      /guidance/studying-in-the-european-union-after-brexit
      /government/publications/family-law-disputes-involving-eu-after-brexit
    ).freeze

    FEATURED_TAXONS = %w(
      /work
      /environment
      /business-and-industry
      /education
    ).freeze

    REJECTED_TAXONS = %w(
      /going-and-being-abroad
      /government/all
      /transport
    ).freeze

    def featured_links
      custom_links + featured_taxons
    end

    def other_links
      @other_links ||= %w(
        /business-uk-leaving-eu
        /uk-nationals-living-eu
        /staying-uk-eu-citizen
      ).map { |path| LinkPresenter.new(path) }
    end

  private

    def custom_links
      @custom_links ||= FEATURED_LINKS.map do |base_path|
        LinkPresenter.new(base_path)
      end
    end

    def featured_taxons
      @featured_taxons ||= FEATURED_TAXONS.map do |base_path|
        featured_taxon = level_one_taxons.detect { |taxon| taxon.base_path == base_path }
        TaxonLinkPresenter.new(featured_taxon)
      end
    end

    def level_one_taxons
      @level_one_taxons ||= ContentItem.find!('/').linked_items('level_one_taxons')
    end
  end
end
