require "integration_spec_helper"

RSpec.feature "Embassies index page" do
  before do
    stub_content_store_has_item("/world/embassies", fetch_fixture("embassies_index"))
    visit "/world/embassies"
  end

  scenario "returns 200 when visiting embassies index page" do
    expect(page.status_code).to eq(200)
  end

  scenario "renders advice for British nationals in locations without embassy offices" do
    node = find("li", text: /^Anguilla$/)
    expect(node).to have_text "British nationals should contact the local authorities"
  end

  scenario "renders advice for British nationals in locations with remote offices" do
    node = find("li", text: /^Afghanistan$/)
    expect(node).to have_text "British nationals should contact the British Embassy Kabul in Qatar"
    expect(node).to have_link("British Embassy Kabul", href: "/world/organisations/british-embassy-kabul")
  end

  scenario "renders advice for British nationals in locations with local offices" do
    node = find("li", text: /^Argentina$/)
    expect(node).to have_link("British Embassy Buenos Aires", href: "/world/organisations/british-embassy-buenos-aires")
  end
end
