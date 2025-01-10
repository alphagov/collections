require "integration_spec_helper"

RSpec.feature "Content store organisations" do
  before do
    stub_content_store_has_item("/government/organisations", organisations_content_hash)
    visit "/government/organisations"
  end

  scenario "returns 200 when visiting organisations page" do
    expect(page.status_code).to eq 200
  end

  scenario "renders webpage title" do
    expect(page.has_title?(I18n.t("organisations.index_title", title: organisations_content_hash[:title]))).to be(true)
  end

  scenario "renders page title" do
    expect(page.has_css?(".gem-c-heading__text", text: organisations_content_hash[:title])).to be(true)
  end

  scenario "has autodiscovery links to the API" do
    expect(page.has_css?("link[rel='alternate'][type='application/json'][href$='/api/organisations']", visible: false)).to be(true)
  end

  scenario "renders organisation filter" do
    expect(page.has_css?(".filter-list__form")).to be(true)
    expect(page.has_css?("label", text: I18n.t("organisations.search_for_department"))).to be(true)
  end

  scenario "renders an organisation_type heading" do
    expect(page.has_css?(".gem-c-heading", text: "Ministerial departments")).to be(true)
  end

  scenario "adds an id to each organisation item" do
    expect(page.has_css?(".organisations-list__item#attorney-generals-office")).to be(true)
  end

  scenario "renders organisation count" do
    expect(page.has_css?(".gem-c-big-number__value", text: "1")).to be(true)
  end

  scenario "renders an accessible version of organisation count" do
    expect(page.has_css?('div[data-filter="count"] > div[aria-hidden="true"]')).to be(true)
    expect(page.has_css?("p.govuk-visually-hidden", text: "There are 2 Non ministerial departments")).to be(true)
  end

  scenario "renders ministerial organisation with crest" do
    expect(page.has_css?(".gem-c-organisation-logo")).to be(true)
  end

  scenario "renders non-ministerial organisation without crest" do
    expect(page.has_css?('a.list__item-title[href="/government/organisations/arts-and-humanities-research-council"]', text: "Arts and Humanities Research Council")).to be(true)
  end

  scenario "displays child organisations count" do
    expect(page.has_content?("Works with 4 agencies and public bodies")).to be(true)
  end

  scenario "renders a 'Details' component for 'Attorney General's Office' with 'Works with 4 agencies and public bodies' summary text" do
    expect(page.has_css?("#attorney-generals-office .govuk-details__summary", text: "Works with 4 agencies and public bodies")).to be(true)
  end

  scenario "renders a list of organisations that an organisation works with" do
    expect(page.has_css?("#toggle_attorney-general-s-office", visible: false)).to be(true)
    expect(page.has_css?("#toggle_attorney-general-s-office h4", text: "Non-ministerial department", visible: false)).to be(true)
    expect(page.has_css?("#toggle_attorney-general-s-office h4", text: "Other", visible: false)).to be(true)

    expect(page.has_css?("#toggle_attorney-general-s-office a[href='/government/organisations/crown-prosecution-service']", text: "Crown Prosecution Service", visible: false)).to be(true)
    expect(page.has_css?("#toggle_attorney-general-s-office a[href='/government/organisations/government-legal-department']", text: "Government Legal Department", visible: false)).to be(true)
    expect(page.has_css?("#toggle_attorney-general-s-office a[href='/government/organisations/serious-fraud-office']", text: "Serious Fraud Office", visible: false)).to be(true)
    expect(page.has_css?("#toggle_attorney-general-s-office a[href='/government/organisations/hm-crown-prosecution-service-inspectorate']", text: "HM Crown Prosecution Service Inspectorate", visible: false)).to be(true)
  end

  scenario "renders links with GA4 tracking" do
    ga4_module = "ol[data-module=ga4-link-tracker]"
    expect(page).to have_css(ga4_module)
    expect(page).to have_css("ol[data-ga4-track-links-only]")

    ga4_link_data = JSON.parse(page.first(ga4_module)["data-ga4-link"])
    expect(ga4_link_data["event_name"]).to eq "navigation"
    expect(ga4_link_data["type"]).to eq "filter"
  end

  scenario "renders the filter input box with GA4 tracking" do
    ga4_module = ".filter-list__form input[data-module=ga4-focus-loss-tracker]"
    expect(page).to have_css(ga4_module)

    ga4_focus_loss_data = JSON.parse(page.first(ga4_module)["data-ga4-focus-loss"])
    expect(ga4_focus_loss_data["event_name"]).to eq "filter"
    expect(ga4_focus_loss_data["type"]).to eq "filter"
    expect(ga4_focus_loss_data["action"]).to eq "filter"
    expect(ga4_focus_loss_data["section"]).to eq "Departments, agencies and public bodies"
  end

private

  def organisations_content_hash
    @content_hash = {
      base_path: "/government/organisations",
      title: "Departments, agencies and public bodies",
      details: {
        ordered_ministerial_departments: [
          {
            title: "Attorney General's Office",
            href: "/government/organisations/attorney-generals-office",
            brand: "attorney-generals-office",
            slug: "attorney-generals-office",
            logo: {
              formatted_title: "Attorney General's Office",
              crest: "single-identity",
            },
            separate_website: false,
            works_with: {
              non_ministerial_department: [
                {
                  title: "Crown Prosecution Service",
                  href: "/government/organisations/crown-prosecution-service",
                },
                {
                  title: "Government Legal Department",
                  href: "/government/organisations/government-legal-department",
                },
                {
                  title: "Serious Fraud Office",
                  href: "/government/organisations/serious-fraud-office",
                },
              ],
              other: [
                {
                  title: "HM Crown Prosecution Service Inspectorate",
                  href: "/government/organisations/hm-crown-prosecution-service-inspectorate",
                },
              ],
              executive_ndpb: [],
            },
          },
        ],
        ordered_non_ministerial_departments: [
          {
            title: "Arts and Humanities Research Council",
            href: "/government/organisations/arts-and-humanities-research-council",
            separate_website: true,
            slug: "arts-and-humanities-research-council",
          },
          {
            title: "Competition and Markets Authority",
            href: "/government/organisations/competition-and-markets-authority",
            slug: "competition-and-markets-authority",
            separate_website: true,
            works_with: {
              non_ministerial_department: [
                {
                  title: "Crown Prosecution Service",
                  href: "/government/organisations/crown-prosecution-service",
                },
              ],
            },
          },
        ],
        ordered_executive_offices: [],
        ordered_agencies_and_other_public_bodies: [],
        ordered_high_profile_groups: [],
        ordered_public_corporations: [],
        ordered_devolved_administrations: [],
      },
    }
  end
end
