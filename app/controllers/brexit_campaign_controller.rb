class BrexitCampaignController < ApplicationController
  EXCLUDED_TAXONS = %w(
    /corporate-information
    /defence-and-armed-forces
    /government/all
    /international
    /life-circumstances
    /regional-and-local-government
    /welfare
  ).freeze

  FEATURED_TAXONS = %w(
    /going-and-being-abroad
    /health-and-social-care
    /transport
    /environment
    /business-and-industry
    /education
  ).freeze

  def show
    @campaign = Organisation.find!("/government/organisations/cabinet-office")
    setup_content_item_and_navigation_helpers(@campaign)

    @taxons = ContentItem
                .find!('/')
                .linked_items('level_one_taxons')
                .reject { |content_item| EXCLUDED_TAXONS.include?(content_item.base_path) }
                .map { |content_item| Taxon.find(content_item.base_path) }
                .map { |taxon| BrexitForCitizensPresenter.new(taxon) }

    @show = Organisations::ShowPresenter.new(@campaign)
    @header = Organisations::HeaderPresenter.new(@campaign)

    @documents = Organisations::DocumentsPresenter.new(@campaign)

    render :show, locals: {
      campaign: @campaign
    }
  end

  def show_b
    @campaign = Organisation.find!("/government/organisations/cabinet-office")
    setup_content_item_and_navigation_helpers(@campaign)

    @level_one_taxons = ContentItem
                          .find!('/')
                          .linked_items('level_one_taxons')
                          .reject { |content_item| EXCLUDED_TAXONS.include?(content_item.base_path) }
                          .map { |content_item| Taxon.find(content_item.base_path) }
                          .map { |taxon| BrexitForCitizensPresenter.new(taxon) }

    @taxons = @level_one_taxons
                .select { |taxon| FEATURED_TAXONS.include?(taxon.base_path) }
                .sort_by { |taxon| FEATURED_TAXONS.index(taxon.base_path) }

    @all_topics_links = @level_one_taxons.map do |taxon|
      {
        path: "https://finder-frontend-pr-706.herokuapp.com/prepare-individual-uk-leaving-eu?topic=#{taxon.base_path}",
        text: taxon.title
      }
    end

    @show = Organisations::ShowPresenter.new(@campaign)
    @header = Organisations::HeaderPresenter.new(@campaign)

    @documents = Organisations::DocumentsPresenter.new(@campaign)

    render :show_b, locals: {
      campaign: @campaign
    }
  end
end
