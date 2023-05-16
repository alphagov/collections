require "integration_spec_helper"

RSpec.feature "Ministers index page" do
  let(:document) { GovukSchemas::Example.find("ministers_index", example_name: "ministers_index-reshuffle-mode-off") }

  before do
    stub_content_store_has_item("/government/ministers", document)
    visit "/government/ministers"
  end

  scenario "returns 200 when visiting ministers page" do
    expect(page.status_code).to eq(200)
  end

  scenario "renders webpage title" do
    expect(page).to have_title(I18n.t("ministers.govuk_title"))
  end

  scenario "renders page title" do
    expect(page).to have_selector(".gem-c-title__text", text: I18n.t("ministers.title"))
  end

  scenario "renders the lead paragraph with anchor links" do
    expect(page).to have_selector(".gem-c-lead-paragraph")
    within(".gem-c-lead-paragraph") do
      expect(page).to have_link("Cabinet ministers", href: "#cabinet-ministers", class: "govuk-link")
    end
  end

  scenario "renders section headers" do
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.cabinet"))
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.also_attends"))
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.by_department"))
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.whips"))
  end

  context "during a reshuffle" do
    let(:document) { GovukSchemas::Example.find("ministers_index", example_name: "ministers_index-reshuffle-mode-on") }

    scenario "renders the reshuffle messaging instead of the usual contents" do
      within(".gem-c-notice") do
        expect(page).to have_text("Reshuffle in progress")
      end
      expect(page).not_to have_selector(".gem-c-lead-paragraph")
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.cabinet"))
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.also_attends"))
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.by_department"))
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.whips"))
    end
  end
end
