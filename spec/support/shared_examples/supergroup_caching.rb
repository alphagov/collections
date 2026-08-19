RSpec.shared_examples "a cached Search API request for supergroup documents" do |expected_expiry:|
  it "fetches documents from Search API and stores them in the cache with an expiry of #{expected_expiry}" do
    allow(cache).to receive(:fetch).and_call_original

    supergroup_documents

    expect(Rails.cache)
      .to have_received(:fetch)
            .with(search_params, expires_in: expected_expiry)

    assert_requested :get, "#{Plek.find('search-api')}/search.json", query: search_params
  end

  it "does not request documents from Search API if the cache already contains a valid copy" do
    freeze_time do
      cache.write(search_params, expires_in: expected_expiry)

      allow(cache).to receive(:fetch).and_call_original

      supergroup_documents

      expect(Rails.cache)
        .to have_received(:fetch)
              .with(search_params, expires_in: expected_expiry)

      assert_not_requested :get, "#{Plek.find('search-api')}/search.json", query: search_params
    end
  end
end
