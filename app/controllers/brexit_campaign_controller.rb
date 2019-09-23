class BrexitCampaignController < ApplicationController
  def show
    @campaign = Campaign.find!("/prepare-eu-exit")
    setup_content_item_and_navigation_helpers(@campaign)

    @featured_links = featured_links
    @other_links = other_links

    render :show, locals: {
      campaign: @campaign,
    }
  end

private

  def featured_links
    %w(
      /visit-europe-brexit
      /buying-europe-brexit
      /guidance/studying-in-the-european-union-after-brexit
      /government/publications/family-law-disputes-involving-eu-after-brexit
    ).map { |base_path| CitizenReadiness::LinkPresenter.new(base_path) }
  end

  def other_links
    %w(
      /business-uk-leaving-eu
      /uk-nationals-living-eu
      /staying-uk-eu-citizen
    ).map { |path| CitizenReadiness::LinkPresenter.new(path) }
  end
end
