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
    expect(page.has_css?(".gem-c-breadcrumbs")).to be
  end

  it "renders the title" do
    expect(page.has_css?(".gem-c-title")).to be
    expect(page.has_css?(".gem-c-title__text", text: "Learn to drive a car: step by step")).to be
  end

  it "renders the step by step navigation component" do
    expect(page.has_selector?(".gem-c-step-nav")).to be
    expect(page.has_selector?(".gem-c-step-nav__title", text: "Check you're allowed to drive")).to be
    expect(page.has_selector?(".gem-c-step-nav__step", count: 7)).to be
  end

  it "hides step content by default" do
    expect(page.has_selector?(".gem-c-step-nav__panel", visible: false)).to be
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
