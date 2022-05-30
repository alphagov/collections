require "integration_spec_helper"

RSpec.feature "Topical Event pages" do
  let(:base_path) { "/government/topical-events/something-very-topical" }
  let(:content_item) do
    {
      "base_path" => base_path,
      "title" => "Something very topical",
      "description" => "This event is happening soon",
      "details" => {
        "body" => "This is a very important topical event.",
      },
    }
  end

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  it "sets the page title" do
    visit base_path
    expect(page).to have_title("#{content_item['title']} - GOV.UK")
  end

  it "sets the page description" do
    visit base_path
    expect(page).to have_text(content_item["description"])
  end

  it "sets the page meta description" do
    visit base_path
    expect(page).to have_selector("meta[name='description'][content='#{content_item['description']}']", visible: :hidden)
  end

  it "sets the body text" do
    visit base_path
    expect(page).to have_text(content_item.dig("details", "body"))
  end
end
