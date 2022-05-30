RSpec.describe TopicalEvent do
  let(:base_path) { "/government/topical-events/something-very-topical" }
  let(:api_data) do
    {
      "base_path" => base_path,
      "title" => "Something very topical",
    }
  end
  let(:content_item) { ContentItem.new(api_data) }
  let(:topical_event) { described_class.new(content_item) }

  it "should have a title" do
    expect(topical_event.title).to eq("Something very topical")
  end
end
