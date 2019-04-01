class BrexitCampaignController < ApplicationController
  def show
    @campaign = Campaign.find!("/prepare-eu-exit")
    setup_content_item_and_navigation_helpers(@campaign)

    presenter = CitizenReadiness::LinksPresenter.new
    @featured_links = presenter.featured_links
    @other_links = presenter.other_links

    render :show, locals: {
      campaign: @campaign
    }
  end
end
