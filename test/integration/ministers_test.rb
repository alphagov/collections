require "integration_test_helper"

class MinistersTest < ActionDispatch::IntegrationTest
  before do
    stub_content_store_has_item("/government/ministers", ministers_content_hash)
    visit "/government/ministers"
  end

  it "returns 200 when visiting ministers page" do
    assert_equal 200, page.status_code
  end

  it "renders webpage title" do
    assert page.has_title?("Ministers - GOV.UK")
  end

  it "renders page title" do
    assert page.has_css?(".gem-c-title__text", text: "Ministers")
  end

private

  def ministers_content_hash
    @content_hash = {
      title: "Ministers",
      details: {},
    }
  end
end
