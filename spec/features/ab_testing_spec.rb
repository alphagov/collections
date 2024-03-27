require "integration_spec_helper"

feature "Viewing a page with the UxmPracticeTest test" do
  include CoronavirusContentItemHelper
  include GovukAbTesting::RspecHelpers

  before do
    stub_content_store_has_item(
      "/coronavirus",
      coronavirus_content_item,
      { max_age: 900, private: false },
    )
  end

  scenario "viewing the A version of the page" do
    with_variant UxmPracticeTest: "A" do
      visit "/coronavirus"

      expect(page.driver.options[:headers]).to eql({ "HTTP_GOVUK_ABTEST_UXMPRACTICETEST" => "A" })

      expect(page.body).to include("<br>").once
    end
  end

  scenario "viewing the B version of the page" do
    with_variant UxmPracticeTest: "B" do
      visit "/coronavirus"

      expect(page.driver.options[:headers]).to eql({ "HTTP_GOVUK_ABTEST_UXMPRACTICETEST" => "B" })

      expect(page.body).to include("<br>").twice
    end
  end
end
