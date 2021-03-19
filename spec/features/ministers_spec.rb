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
    expect(page).to have_title("Ministers - GOV.UK")
  end

  scenario "renders page title" do
    expect(page).to have_selector(".gem-c-title__text", text: "Ministers")
  end

  scenario "renders section headers" do
    expect(page).to have_selector(".gem-c-heading", text: "Cabinet ministers")
    expect(page).to have_selector(".gem-c-heading", text: "Also attends Cabinet")
    expect(page).to have_selector(".gem-c-heading", text: "Ministers by department")
    expect(page).to have_selector(".gem-c-heading", text: "Whips")
  end

private

  def ministers_content_hash
    @content_hash = {
      title: "Ministers",
      details: {},
    }
  end
end
