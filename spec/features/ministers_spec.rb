require "integration_test_helper"

class MinistersTest < ActionDispatch::IntegrationTest
  before do
    stub_content_store_has_item("/government/ministers", ministers_content_hash)
    visit "/government/ministers"
  end

  it "returns 200 when visiting ministers page" do
    expect(page.status_code).to eq(200)
  end

  it "renders webpage title" do
    expect(page.has_title?("Ministers - GOV.UK")).to be
  end

  it "renders page title" do
    expect(page.has_css?(".gem-c-title__text", text: "Ministers")).to be
  end

  it "renders section headers" do
    expect(page.has_css?(".gem-c-heading", text: "Cabinet ministers")).to be
    expect(page.has_css?(".gem-c-heading", text: "Also attends Cabinet")).to be
    expect(page.has_css?(".gem-c-heading", text: "Ministers by department")).to be
    expect(page.has_css?(".gem-c-heading", text: "Whips")).to be
  end

private

  def ministers_content_hash
    @content_hash = {
      title: "Ministers",
      details: {},
    }
  end
end
