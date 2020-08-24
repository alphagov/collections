require "integration_test_helper"
require "govuk-content-schema-test-helpers"

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = "frontend" # or 'publisher_v2'
  config.project_root = Rails.root
end

class StepNavPageTest < ActionDispatch::IntegrationTest
  before do
    sample = GovukContentSchemaTestHelpers::Examples.new.get("step_by_step_nav", "learn_to_drive_a_car")
    content_item = JSON.parse(sample)
    stub_content_store_has_item(content_item["base_path"], content_item)

    visit content_item["base_path"]
  end

  it "renders breadcrumbs" do
    assert page.has_css?(".gem-c-breadcrumbs")
  end

  it "renders the title" do
    assert page.has_css?(".gem-c-title")
    assert page.has_css?(".gem-c-title__text", text: "Learn to drive a car: step by step")
  end

  it "renders the step by step navigation component" do
    assert page.has_selector?(".gem-c-step-nav")
    assert page.has_selector?(".gem-c-step-nav__title", text: "Check you're allowed to drive")
    assert page.has_selector?(".gem-c-step-nav__step", count: 7)
  end

  it "hides step content by default" do
    assert page.has_selector?(".gem-c-step-nav__panel", visible: false)
  end

  it "works for a generated example" do
    content_item = step_nav_example

    stub_content_store_has_item(content_item["base_path"], content_item)

    get content_item["base_path"]
    assert_response 200
    assert_select "title", "#{content_item['title']} - GOV.UK"
  end

  def step_nav_example
    schema = GovukSchemas::Schema.find(frontend_schema: "step_by_step_nav")

    GovukSchemas::RandomExample.new(schema: schema).payload.tap do |item|
      item["base_path"] = "/learn-to-drive-a-car"
    end
  end
end
