require "integration_spec_helper"

RSpec.feature "Topical Event pages" do
  let(:base_path) { "/government/topical-events/something-very-topical" }
  let(:content_item) do
    {
      "base_path" => base_path,
    }
  end

  before do
    stub_content_store_has_item(base_path, content_item)
  end
end
