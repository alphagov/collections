RSpec.describe TopicalEvent do
  let(:base_path) { "/government/topical-events/something-very-topical" }
  let(:api_data) do
    {
      "base_path" => base_path,
      "title" => "Something very topical",
      "description" => "This event is happening soon",
      "details" => {
        "body" => "This is a very important topical event.",
        "end_date" => "2016-04-28T00:00:00+00:00",
      },
    }
  end
  let(:content_item) { ContentItem.new(api_data) }
  let(:topical_event) { described_class.new(content_item) }

  it "should have a title" do
    expect(topical_event.title).to eq("Something very topical")
  end

  it "should have a description" do
    expect(topical_event.description).to eq("This event is happening soon")
  end

  it "show have body text" do
    expect(topical_event.body).to eq("This is a very important topical event.")
  end

  context "when the event is current" do
    it "does not mark as archived" do
      Timecop.freeze("2016-04-18") do
        expect(topical_event.archived?).to be false
      end
    end
  end

  context "when the event is archived" do
    it "shows the archived text" do
      Timecop.freeze("2016-05-18") do
        expect(topical_event.archived?).to be true
      end
    end
  end
end
