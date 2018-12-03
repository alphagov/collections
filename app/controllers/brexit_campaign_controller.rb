class BrexitCampaignController < ApplicationController
  def show
    @campaign = Organisation.find!("/government/organisations/cabinet-office")
    setup_content_item_and_navigation_helpers(@campaign)

    @taxons = BrexitTaxonsPresenter.new.call

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
        { text: "running a business", href: "https://tiger-team-5-campaign-business-ready.glitch.me/" },
        { text: "a UK national living in the EU", href: "https://uk-nationals-in-eu.herokuapp.com" },
        { text: "an EU national living in the UK", href: "https://draft-origin.publishing.service.gov.uk/continue-live-uk-after-leaves-eu?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjMWU0ZGJhNy1kMzU1LTQ1ZTQtYTk0OC01OTI3MmIzZWUzYWEifQ.13RMXDLpk-lg0d8j8UEXEZAR58tYgP6jkaFPGFNXs88" },
      ]
    }
  end
end
