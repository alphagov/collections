require "integration_spec_helper"

RSpec.feature "Topical Event pages" do
  let(:base_path) { "/government/topical-events/something-very-topical" }
  let(:content_item) do
    {
      "base_path" => base_path,
      "title" => "Something very topical",
    }
  end

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  it "sets the page title" do
    visit base_path
    expect(page).to have_title("#{content_item['title']} - GOV.UK")
  end
end
