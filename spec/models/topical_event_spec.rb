RSpec.describe TopicalEvent do
  let(:api_data) { fetch_fixture("topical_event") }
  let(:content_item) { ContentItem.new(api_data) }
  let(:base_path) { content_item.base_path }
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

private

  def fetch_fixture(filename)
    json = File.read(
      Rails.root.join("spec", "fixtures", "content_store", "#{filename}.json"),
    )
    JSON.parse(json)
  end
end
