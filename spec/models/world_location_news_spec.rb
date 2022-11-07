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

  it "should map the ordered featured links" do
    expect(world_location_news.ordered_featured_links).to eq(
      [
        {
          path: "https://www.gov.uk/somewhere",
          text: "A link to somewhere",
        },
        {
          path: "https://www.gov.uk/somewhere2",
          text: "A second link to somewhere",
        },
      ],
    )
  end

  it "should order the translations" do
    expect(world_location_news.ordered_translations).to eq(
      [
        {
          locale: "en",
          base_path: "/world/somewhere",
          text: "English",
          active: true,
        },
        {
          locale: "cy",
          base_path: "/world/somewhere.cy",
          text: "Cymraeg",
          active: false,
        },
      ],
    )
  end

  context "document lists" do
    let(:default_params) do
      { filter_world_locations: [base_path.sub(%r{/world/}, "").sub(%r{/news}, "")],
        count: 3,
        order: "-public_timestamp",
        fields: SearchApiFields::WORLD_LOCATION_NEWS_SEARCH_FIELDS }
    end

    it "should make correct call to search api for announcements" do
      expect(Services.search_api)
        .to receive(:search)
        .with(default_params.merge({ filter_content_purpose_supergroup: "news_and_communications" }))
        .and_return({ "results" => [] })

      world_location_news.announcements
    end

    it "should make correct call to search api for publications" do
      expect(Services.search_api)
          .to receive(:search)
          .with(default_params.merge({ filter_content_purpose_supergroup: %w[guidance_and_regulation policy_and_engagement transparency] }))
          .and_return({ "results" => [] })

      world_location_news.publications
    end

    it "should make correct call to search api for statistics" do
      expect(Services.search_api)
          .to receive(:search)
          .with(default_params.merge({ filter_content_purpose_subgroup: "statistics" }))
          .and_return({ "results" => [] })

      world_location_news.statistics
    end
  end

  it "should include the type" do
    expect(world_location_news.type).to eq("world_location")
  end

  it "should map the organisations" do
    expect(world_location_news.organisations).to eq([
      {
        content_id: "org-1",
        base_path: "government/organisations/department-1",
        title: "Department 1",
        details: {
          logo: {
            crest: "single-identity",
          },
          brand: "department-1",
        },
      }.deep_stringify_keys,
      {
        content_id: "org-2",
        base_path: "government/organisations/department-2",
        title: "Department 2",
        details: {
          logo: {
            crest: "single-identity",
          },
          brand: "department-2",
        },
      }.deep_stringify_keys,
    ])
  end
end
