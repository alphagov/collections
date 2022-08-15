RSpec.describe WorldLocationNews do
  let(:api_data) { fetch_fixture("world_location_news") }
  let(:content_item) { ContentItem.new(api_data) }
  let(:base_path) { content_item.base_path }
  let(:world_location_news) { described_class.new(content_item) }

  it "should have a title" do
    expect(world_location_news.title).to eq("UK and Mock Country")
  end

  it "should have a description" do
    expect(world_location_news.description).to eq("Find out about the relations between the UK and Mock Country")
  end

  it "should map the ordered featured documents with truncated description where this exceeds 160 chars" do
    expect(world_location_news.ordered_featured_documents.first).to eq(
      {
        href: "https://www.gov.uk/somewhere",
        image_src: "https://www.gov.uk/someimage.png",
        image_alt: "Alt text for the image",
        heading_text: "A document related to this location",
        description: "Very interesting document content. However this goes over the 160 character limit so when displayed this should be truncated in order to display the content...",
        context: {
          date: Date.parse("2022-07-28"),
          text: "News",
        },
      },
    )
  end

  it "should map the ordered featured documents with offsite links that have no date" do
    expect(world_location_news.ordered_featured_documents.second).to eq(
      {
        href: "https://www.gov.uk/somewhere-without-an-update-date",
        image_src: "https://www.gov.uk/someimage2.png",
        image_alt: "Alt text for the second image",
        heading_text: "A document related to this location with no updated date",
        description: "Very interesting document content.",
        context: {
          date: nil,
          text: "Blog",
        },
      },
    )
  end

  it "should return the mission statement" do
    expect(world_location_news.mission_statement).to eq("Our mission is to test world location news.")
  end
end
