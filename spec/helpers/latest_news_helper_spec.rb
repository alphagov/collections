RSpec.describe LatestNewsHelper do
  include OrganisationHelpers
  include LatestNewsHelper

  describe "#latest_news_items" do
    let!(:no10) { Organisation.new(ContentItem.new(organisation_with_featured_documents_and_is_no_10)) }

    before do
      stub_latest_news_for_organisation("prime-ministers-office-10-downing-street")
    end

    it "gets the latest news items" do
      results = latest_news_items(no10)

      expect(results.count).to eq(2)
    end

    it "retreives the image for the first news item if requested" do
      results = latest_news_items(no10, get_first_image: true)

      expect(results[0][:image_src]).to eq("https://www.example.com/latest-news-item-with-image.png")
      expect(results[0][:image_alt]).to eq("Example Image")

      expect(results[1][:image_src]).to be_nil
      expect(results[1][:image_alt]).to be_nil
    end

    context "with the first news item missing" do
      before do
        stub_latest_news_for_organisation_missing_item("prime-ministers-office-10-downing-street")
      end

      it "falls back to a default image" do
        results = latest_news_items(no10, get_first_image: true)

        expect(results[0][:image_src]).to eq("https://assets.publishing.service.gov.uk/media/5a37dae940f0b649cceb1841/s300_number10.jpg")
        expect(results[0][:image_alt]).to eq("Front door of No. 10 Downing Street")

        expect(results[1][:image_src]).to be_nil
        expect(results[1][:image_alt]).to be_nil
      end
    end
  end
end
