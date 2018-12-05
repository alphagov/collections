class BrexitCampaignController < ApplicationController
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

    # @documents = Organisations::DocumentsPresenter.new(@campaign)
    @documents = Organisations::DocumentsPresenter.new(@campaign)

    render :show, locals: {
      campaign: @campaign
    }
  end

private

  EXCLUDED_TAXONS = %w(
                        /corporate-information
                        /defence-and-armed-forces
                        /international
                        /life-circumstances
                        /regional-and-local-government
                        /welfare
                      )
end
