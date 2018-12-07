class BrexitCampaignController < ApplicationController

  def show
    @campaign = Organisation.find!("/government/organisations/cabinet-office")
    setup_content_item_and_navigation_helpers(@campaign)

    @taxons = BrexitTaxonsPresenter.new.call

    @campaign_links = {
      random: SecureRandom.hex(4),
      section_title: "There's different guidance if you're:",
      contents_list_links: [
        { text: "Running a business", href: "https://tiger-team-5-campaign-business-ready.glitch.me/" },
        { text: "A UK national living in the EU", href: "https://uk-nationals-in-eu.herokuapp.com" },
        { text: "An EU national living in the UK", href: "https://draft-origin.publishing.service.gov.uk/continue-live-uk-after-leaves-eu?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjMWU0ZGJhNy1kMzU1LTQ1ZTQtYTk0OC01OTI3MmIzZWUzYWEifQ.13RMXDLpk-lg0d8j8UEXEZAR58tYgP6jkaFPGFNXs88" },
      ]
    }

    render :show, locals: {
      campaign: @campaign
    }
  end
end
