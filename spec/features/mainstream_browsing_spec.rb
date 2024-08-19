require "integration_spec_helper"

RSpec.feature "Mainstream browsing" do
  include SearchApiHelpers

  scenario "that we can handle all examples" do
    # Shuffle the examples to ensure tests don't become order dependent
    schemas = GovukSchemas::Example.find_all("mainstream_browse_page").shuffle

    schemas.each do |content_item|
      stub_content_store_has_item(content_item["base_path"], content_item)

      search_api_has_documents_for_browse_page(
        content_item["content_id"],
        %w[
          employee-tax-codes
          get-paye-forms-p45-p60
          pay-paye-penalty
          pay-paye-tax
          pay-psa
          payroll-annual-reporting
        ],
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )

      visit content_item["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-breadcrumbs")
    end
  end

  context "when AB testing popular tasks" do
    include GovukAbTesting::RspecHelpers

    before do
      GovukAbTesting.configure do |config|
        config.acceptance_test_framework = :capybara
      end
    end

    context "when visiting /browse/benefits" do
      before do
        stub_content_store_has_item(
          "/browse/benefits",
          base_path: "/browse/benefits",
          title: "Benefits",
        )
      end

      scenario "variant A" do
        with_variant PopularTasks: "A" do
          visit "/browse/benefits"
          expect(page).to have_link("Check benefits and financial support you can get")
        end
      end

      scenario "variant B" do
        with_variant PopularTasks: "B" do
          visit "/browse/benefits"
          expect(page).to have_link("Check benefits and financial support you can get")
        end
      end

      scenario "control variant" do
        visit "/browse/benefits"
        expect(page).to have_link("Check benefits and financial support you can get")
      end
    end

    context "when visiting /browse/business" do
      before do
        stub_content_store_has_item(
          "/browse/business",
          base_path: "/browse/business",
          title: "Business",
        )
      end

      scenario "variant A" do
        with_variant PopularTasks: "A" do
          visit "/browse/business"
          expect(page).to have_link("HMRC online services: sign in or set up an account")
          expect(page).to have_link("Self Assessment tax returns")
          expect(page).to have_link("Pay employers' PAYE")
        end
      end

      scenario "variant B" do
        with_variant PopularTasks: "B" do
          visit "/browse/business"
          expect(page).to have_link("HMRC online services: sign in or set up an account")
          expect(page).to have_link("Self Assessment tax returns")
          expect(page).to have_link("Pay employers' PAYE")
        end
      end

      scenario "control variant" do
        visit "/browse/business"
        expect(page).to have_link("HMRC online services: sign in or set up an account")
        expect(page).to have_link("Self Assessment tax returns")
        expect(page).to have_link("Pay employers' PAYE")
      end
    end
  end
end
