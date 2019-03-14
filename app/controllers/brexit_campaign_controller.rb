class BrexitCampaignController < ApplicationController
  def show
    @campaign = Campaign.find!("/prepare-eu-exit")
    setup_content_item_and_navigation_helpers(@campaign)

    presenter = CitizenReadiness::LinksPresenter.new
    @featured_links = presenter.featured_links
    @other_links = presenter.other_links

    @campaign_links = campaign_links

    render :show, locals: {
      campaign: @campaign
    }
  end

private

  def campaign_links
    {
      section_title: "There's different guidance if you're:",
      contents_list_links: [
        { text: "running a business", href: "/business-uk-leaving-eu" },
        { text: "a UK national living in the EU", href: "/uk-nationals-living-eu" },
        { text: "an EU national and you want to continue living in the UK", href: "/staying-uk-eu-citizen" },
      ]
    }
  end
end
