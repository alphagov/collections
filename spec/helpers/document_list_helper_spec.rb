RSpec.describe DocumentListHelper do
  context "on a topical event page" do
    it "correctly constructs search urls for different document types" do
      expected_publication_url = "/search/all?topical_events%5B%5D=something-very-topical"
      expected_consultation_url = "/search/policy-papers-and-consultations?content_store_document_type%5B%5D=open_consultations&content_store_document_type%5B%5D=closed_consultations&topical_events%5B%5D=something-very-topical"
      expected_announcement_url = "/search/news-and-communications?topical_events%5B%5D=something-very-topical"
      expected_latest_url = "/search/all?order=updated-newest&topical_events%5B%5D=something-very-topical"
      expected_guidance_and_regulation_url = "/search/all?content_purpose_supergroup=guidance_and_regulation&topical_events%5B%5D=something-very-topical"

      expected_results = {
        publication: expected_publication_url,
        consultation: expected_consultation_url,
        announcement: expected_announcement_url,
        latest: expected_latest_url,
        guidance_and_regulation: expected_guidance_and_regulation_url,
      }

      expected_results.each do |document_type, expected_url|
        expect(search_url(:topical_event, document_type, "something-very-topical")).to eq(expected_url)
      end
    end
  end

  context "on a world location news page" do
    it "correctly constructs search urls for different document types" do
      expected_latest_url = "/search/all?order=updated-newest&world_locations%5B%5D=somewhere"

      expected_results = {
        latest: expected_latest_url,
      }

      expected_results.each do |document_type, expected_url|
        expect(search_url(:world_location_news, document_type, "somewhere")).to eq(expected_url)
      end
    end
  end
end
