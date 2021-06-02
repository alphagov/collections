require "integration_spec_helper"

RSpec.feature "Minister pages" do
  before do
    stub_content_store_has_item("/government/ministers", ministers_content_hash)
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

  scenario "renders section headers" do
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.cabinet"))
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.also_attends"))
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.by_department"))
    expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.whips"))
  end

private

  def ministers_content_hash
    @content_hash = {
      title: I18n.t("ministers.title"),
      details: {},
    }
  end
end
