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

    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page")
    browse_slugs = I18n.t("browse.popular_links").keys

    before do
      GovukAbTesting.configure do |config|
        config.acceptance_test_framework = :capybara
      end
    end

    context "Control variants" do
      scenario "when visiting business and benefits i.e. pages that originally had popular tasks" do
        with_variant PopularTasks: "C" do
          content_item["base_path"] = "/browse/business"
          stub_content_store_has_item("/browse/business", content_item)
          visit "/browse/business"
          expect(page).to have_content("Popular tasks")

          links = I18n.t("browse.popular_links.business.control")
          links.each do |link|
            expect(page).to have_link(link["title"])
          end

          content_item["base_path"] = "/browse/benefits"
          stub_content_store_has_item("/browse/benefits", content_item)
          visit "/browse/benefits"
          expect(page).to have_content("Popular tasks")

          links = I18n.t("browse.popular_links.benefits.control")
          links.each do |link|
            expect(page).to have_link(link["title"])
          end
        end

        with_variant PopularTasks: "Z" do
          content_item["base_path"] = "/browse/business"
          stub_content_store_has_item("/browse/business", content_item)
          visit "/browse/business"
          expect(page).to have_content("Popular tasks")

          links = I18n.t("browse.popular_links.business.control")
          links.each do |link|
            expect(page).to have_link(link["title"])
          end

          content_item["base_path"] = "/browse/benefits"
          stub_content_store_has_item("/browse/benefits", content_item)
          visit "/browse/benefits"
          expect(page).to have_content("Popular tasks")

          links = I18n.t("browse.popular_links.benefits.control")
          links.each do |link|
            expect(page).to have_link(link["title"])
          end
        end
      end

      scenario "when visiting pages that originally had no popular tasks" do
        slugs_with_no_popular_tasks_originally = browse_slugs - %i[benefits business]

        slugs_with_no_popular_tasks_originally.each do |browse_slug|
          browse_path = "/browse/#{browse_slug}"
          content_item["base_path"] = browse_path
          stub_content_store_has_item(browse_path, content_item)

          with_variant PopularTasks: "C" do
            visit browse_path
            expect(page).not_to have_content("Popular tasks")
          end

          with_variant PopularTasks: "Z" do
            visit browse_path
            expect(page).not_to have_content("Popular tasks")
          end
        end
      end
    end

    browse_slugs.each do |browse_slug|
      browse_path = "/browse/#{browse_slug}"

      context "when visiting #{browse_path}" do
        before do
          content_item["base_path"] = browse_path
          stub_content_store_has_item(browse_path, content_item)
        end

        scenario "variant A" do
          with_variant PopularTasks: "A" do
            visit browse_path
            links = I18n.t("browse.popular_links.#{browse_slug}.variant_a")
            links.each do |link|
              expect(page).to have_link(link["title"])
            end
          end
        end

        scenario "variant B" do
          with_variant PopularTasks: "B" do
            visit browse_path
            links = I18n.t("browse.popular_links.#{browse_slug}.variant_b")
            links.each do |link|
              expect(page).to have_link(link["title"])
            end
          end
        end
      end
    end
  end

  it "renders the GOV.UK Chat promo" do
    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page").tap do |item|
      item["base_path"] = GovukChatPromoHelper::GOVUK_CHAT_PROMO_BASE_PATHS.first
    end

    stub_content_store_has_item(content_item["base_path"], content_item)

    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      visit content_item["base_path"]
      expect(page).to have_selector(".gem-c-chat-entry")
    end
  end
end
