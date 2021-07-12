require "integration_spec_helper"
require "govuk-content-schema-test-helpers"

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = "frontend" # or 'publisher_v2'
  config.project_root = Rails.root
end

RSpec.feature "Step by step nav pages" do
  include GovukAbTesting::RspecHelpers
  before do
    sample = GovukContentSchemaTestHelpers::Examples.new.get("step_by_step_nav", "learn_to_drive_a_car")
    content_item = JSON.parse(sample)
    stub_content_store_has_item(content_item["base_path"], content_item)

    visit content_item["base_path"]
  end

  it "renders breadcrumbs" do
    expect(page).to have_selector(".gem-c-breadcrumbs")
  end

  it "renders the title" do
    expect(page).to have_selector(".gem-c-title")
    expect(page).to have_selector(".gem-c-title__text", text: "Learn to drive a car: step by step")
  end

  it "renders the step by step navigation component" do
    expect(page).to have_selector(".gem-c-step-nav")
    expect(page).to have_selector(".gem-c-step-nav__title", text: "Check you're allowed to drive")
    expect(page).to have_selector(".gem-c-step-nav__step", count: 7)
  end

  it "hides step content by default" do
    expect(page).to have_selector(".gem-c-step-nav__panel", visible: false)
  end

  it "works for a generated example" do
    content_item = step_nav_example

    stub_content_store_has_item(content_item["base_path"], content_item)

    visit content_item["base_path"]
    expect(page).to have_title("#{content_item['title']} - GOV.UK")
  end

  context "SaB A/B test: user is in segment A" do
    it "does not show the banner" do
      with_variant StartABusinessSegment: "A" do
        setup_for_sab_ab_test("true")
        expect(page).to_not have_selector(".gem-c-intervention")
      end
    end
  end

  context "SaB A/B test: user is in segment B" do
    it "show the banner in a sab page" do
      with_variant StartABusinessSegment: "B" do
        setup_for_sab_ab_test("true")
        expect(page).to have_selector(".gem-c-intervention")
      end
    end
  end

  context "SaB A/B test: user is in segment C" do
    it "does not show the banner" do
      with_variant StartABusinessSegment: "C" do
        setup_for_sab_ab_test("true")
        expect(page).to_not have_selector(".gem-c-intervention")
      end
    end
  end

  def setup_for_sab_ab_test(is_sab_page_header_value)
    content_item = step_nav_example
    stub_content_store_has_item(content_item["base_path"], content_item)

    headers = {
      "HTTP_GOVUK_ABTEST_ISSTARTABUSINESSPAGE" => is_sab_page_header_value,
    }
    page.driver.options[:headers] ||= {}
    page.driver.options[:headers].merge!(headers)

    visit content_item["base_path"]
  end

  def step_nav_example
    schema = GovukSchemas::Schema.find(frontend_schema: "step_by_step_nav")

    GovukSchemas::RandomExample.new(schema: schema).payload.tap do |item|
      item["base_path"] = "/learn-to-drive-a-car"
    end
  end
end
