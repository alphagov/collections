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

  scenario "renders cabinet ministers in the relevant section" do
    within("#cabinet li", match: :first) do
      expect(page).to have_text("The Rt Hon")
      expect(page).to have_text("Rishi Sunak MP")
      expect(page).to have_text("Prime Minister, First Lord of the Treasury, Minister for the Civil Service, Minister for the Union")
    end
  end

  scenario "cabinet section shows ministers' role payment type info where required" do
    greg_hands = all("#cabinet li")[1]
    expect(greg_hands).to have_text("Greg Hands MP")
    expect(greg_hands).to have_text("Minister without Portfolio")
    expect(greg_hands).to have_text("Unpaid")
  end

  scenario "renders ministers who also attend cabinet in the relevant section" do
    within("#also-attends-cabinet li", match: :first) do
      expect(page).to have_text("The Rt Hon")
      expect(page).to have_text("Simon Hart MP")
      expect(page).to have_text("Parliamentary Secretary to the Treasury (Chief Whip)")
    end
  end

  scenario "also attends cabinet section shows ministers' role payment type info where required" do
    john_glen = all("#also-attends-cabinet li")[1]
    expect(john_glen).to have_text("John Glen MP")
    expect(john_glen).to have_text("Chief Secretary to the Treasury")
    expect(john_glen).to have_text("Unpaid")
  end

  scenario "renders whips by whip organisation in the relevant section" do
    within("#whip-house-of-commons") do
      expect(page).to have_text("House of Commons")
    end
  end

  scenario "the whip section shows only ministers' whip roles" do
    lord_caine = all("#whip-baronesses-and-lords-in-waiting li")[1]
    expect(lord_caine).to have_text("Lord Caine")
    expect(lord_caine).to have_text("Lord in Waiting")
    expect(lord_caine).to_not have_text("Parliamentary Under Secretary of State")
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
