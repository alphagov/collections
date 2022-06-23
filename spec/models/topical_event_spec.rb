RSpec.describe TopicalEvent do
  include SearchApiHelpers

  let(:api_data) { fetch_fixture("topical_event") }
  let(:content_item) { ContentItem.new(api_data) }
  let(:base_path) { content_item.base_path }
  let(:topical_event) { described_class.new(content_item) }

  before do
    stub_search(body: { results: [] })
  end

  it "should have a title" do
    expect(topical_event.title).to eq("Something very topical")
  end

  it "should have a description" do
    expect(topical_event.description).to eq("This event is happening soon")
  end

  it "should return the image URL and alt text" do
    expect(topical_event.image_url).to eq("https://www.gov.uk/some-image.png")
    expect(topical_event.image_alt_text).to eq("Text describing the image")
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

  it "should have about link link" do
    expect(topical_event.about_page_url).to eq("#{base_path}/about")
  end

  it "should have about link text" do
    expect(topical_event.about_page_link_text).to eq("Read more about this event")
  end

  it "should map the social media links" do
    expect(topical_event.social_media_links).to eq([
      {
        href: "https://www.facebook.com/a-topical-event",
        text: "Facebook",
        icon: "facebook",
      },
      {
        href: "https://www.twitter.com/a-topical-event",
        text: "Twitter",
        icon: "twitter",
      },
    ])
  end

  it "should map the social media links" do
    expect(topical_event.ordered_featured_documents).to eq([
      {
        href: "https://www.gov.uk/somewhere",
        image_src: "https://www.gov.uk/someimage.png",
        image_alt: "Alt text for the image",
        heading_text: "A document related to this event",
        description: "Very interesting document content.",
      },
    ])
  end

  context "document lists" do
    let(:default_params) do
      { filter_topical_events: [base_path.sub(%r{/government/topical-events/}, "")],
        count: 3,
        order: "-public_timestamp",
        fields: SearchApiFields::TOPICAL_EVENTS_SEARCH_FIELDS }
    end

    it "should make correct call to search api for announcements" do
      announcement_formats = %w[press_release news_article news_story fatality_notice speech written_statement oral_statement authored_article government_response]

      expect(Services.search_api)
        .to receive(:search)
        .with(default_params.merge({ filter_content_store_document_type: announcement_formats }))
        .and_return({ "results" => [] })

      topical_event.announcements
    end

    it "should make correct call to search api for consultations" do
      expect(Services.search_api)
          .to receive(:search)
          .with(default_params.merge({ filter_format: "consultation" }))
          .and_return({ "results" => [] })

      topical_event.consultations
    end

    it "should make correct call to search api for publications" do
      expect(Services.search_api)
          .to receive(:search)
          .with(default_params.merge({ filter_format: "publication" }))
          .and_return({ "results" => [] })

      topical_event.publications
    end
  end

private

  def fetch_fixture(filename)
    json = File.read(
      Rails.root.join("spec", "fixtures", "content_store", "#{filename}.json"),
    )
    JSON.parse(json)
  end
end
