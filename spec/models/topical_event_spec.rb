RSpec.describe TopicalEvent do
  let(:base_path) { "/government/topical-events/something-very-topical" }
  let(:api_data) do
    {
      "base_path" => base_path,
    }
  end
  let(:content_item) { ContentItem.new(api_data) }
  let(:topical_event) { described_class.new(content_item) }
end
