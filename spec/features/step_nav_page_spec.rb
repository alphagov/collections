require "integration_spec_helper"

RSpec.feature "Step by step nav pages" do
  before do
    content_item = GovukSchemas::Example.find("step_by_step_nav", example_name: "learn_to_drive_a_car")
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

  def step_nav_example
    schema = GovukSchemas::Schema.find(frontend_schema: "step_by_step_nav")

    GovukSchemas::RandomExample.new(schema:).payload.tap do |item|
      item["base_path"] = "/learn-to-drive-a-car"
    end
  end
end
