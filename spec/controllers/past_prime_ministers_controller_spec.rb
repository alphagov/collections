RSpec.describe PastPrimeMinistersController do
  let(:base_path) { "/government/history/past-prime-ministers" }
  let(:past_pm_id) { "a-pm" }
  let(:content_item) do
    {
      base_path: "#{base_path}/#{past_pm_id}",
      title: "a past PM",
      details: {
        born: "1900",
        died: "2000",
        interesting_facts: "a fact",
        major_acts: "an act",
        political_party: "A party",
        dates_in_office: [{ end_year: 2005, start_year: 2000 }],
      },
      links: { ordered_related_items: [] },
    }
  end

  describe "GET show" do
    it "has a success response for an existent pm" do
      stub_content_store_has_item("#{base_path}/#{past_pm_id}", content_item)

      get :show, params: { id: "a-pm" }

      expect(response).to have_http_status(:success)
    end

    it "has a not found response for a non-existent pm" do
      id = "not-a-pm"
      stub_content_store_does_not_have_item("#{base_path}/#{id}")
      get :show, params: { id: }

      expect(response).to have_http_status(:not_found)
    end
  end
end
