RSpec.describe CostOfLivingLandingPagePresenter do
  let(:content_item) do
    { body:
      { heading: "Available support",
        accordion_content: [
          { heading: "Support with your income",
            content: [
              { subheading: nil,
                links: [
                  { link_text: "Find out what benefits and financial support you may be able to get", href: "https://www.gov.uk/check-benefits-financial-support" },
                  { link_text: "Check if you’re getting the minimum wage", href: "https://www.gov.uk/am-i-getting-minimum-wage" },
                ] },
              { inset_text: "The Money Helper service provides free, confidential and impartial help tailored to individual needs.", link_text: "Use the Money Helper service", href: "https://www.moneyhelper.org.uk/" },
              { subheading: "Check if you’re eligible for Universal Credit", links: [{ link_text: "Universal Credit in England, Scotland and Wales", href: "https://www.gov.uk/universal-credit/" }, { link_text: "Universal Credit in Northern Ireland", href: "https://www.nidirect.gov.uk/campaigns/universal-credit" }] },
            ] },
        ] } }
  end

  let(:presenter) do
    described_class.new(content_item)
  end

  it "provides getter methods for all component keys defined in the YAML" do
    # To keep the yaml and presenter in sync. If it fails update COMPONENTS in the presenter
    cost_of_living_hardcoded_content = YAML.load_file(Rails.root.join("config/cost_of_living_landing_page/content_item.yml")).deep_symbolize_keys
    presenter = described_class.new(cost_of_living_hardcoded_content)

    expect(described_class::COMPONENTS).to match(cost_of_living_hardcoded_content.keys)
    cost_of_living_hardcoded_content.each_key do |key|
      expect(presenter).to respond_to(key)
    end
  end

  describe "#link_clicked_track_data" do
    let(:track_action) { "Support with your bills" }

    it "returns correct tracking attributes for an internal link" do
      expect(presenter.link_clicked_track_data(
               track_action: track_action,
               href: "/guidance/universal-credit-childcare-costs",
             )).to eq({
               track_category: "contentsClicked",
               track_action: "Support with your bills",
               track_label: "/guidance/universal-credit-childcare-costs",
               track_count: "contentLink",
             })
    end

    it "returns number of links tracking attribute for an external link" do
      expect(presenter.link_clicked_track_data(
               track_action: track_action,
               href: "https://www.moneyhelper.org.uk/",
             )).to eq({ track_count: "contentLink" })
    end
  end
end
