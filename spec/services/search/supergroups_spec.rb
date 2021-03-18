describe Search::Supergroups do
  include OrganisationHelpers

  let(:slug_for_org_with_docs) { "sitting-on-the-docs-of-the-bay" }
  let(:slug_for_org_with_no_docs) { "i-got-no-docs-and-i-cannot-lie" }

  let(:supergroups) { described_class.new(organisation_slug: slug_for_org_with_docs) }
  let(:no_docs_supergroups) { described_class.new(organisation_slug: slug_for_org_with_no_docs) }

  before do
    Search::Supergroups::SUPERGROUP_TYPES.each do |supergroup|
      stub_search_api_supergroup_request(supergroup, slug_for_org_with_docs, [raw_search_api_result])
      stub_search_api_supergroup_request(supergroup, slug_for_org_with_no_docs, [])
    end
  end

  describe "#has_groups?" do
    it "returns false if no groups have documents" do
      expect(no_docs_supergroups.has_groups?).to eq(false)
    end

    it "returns true if at least one supergroup has documents" do
      expect(supergroups.has_groups?).to eq(true)
    end
  end

  describe "#groups" do
    it "returns an array of supergroups" do
      expect(supergroups.groups.first).to be_kind_of(Search::Supergroup)
    end

    it "returns an array of supergroups regardless of doc responses" do
      expect(no_docs_supergroups.groups.map(&:content_purpose_supergroup)).to eq(supergroups.groups.map(&:content_purpose_supergroup))
    end

    it "applies the given additional search parameters" do
      supergroups.groups.each do |group|
        params = Search::Supergroups::SUPERGROUP_ADDITIONAL_SEARCH_PARAMS.fetch(
          group.content_purpose_supergroup,
          {},
        )
        query = group.documents_query
        expect(query).to eq(query.merge(params))
      end
    end
  end

  def raw_search_api_result
    {
      "title" => "Quiddich World Cup 2022 begins",
      "link" => "/government/news/its-coming-home",
      "content_store_document_type" => "news_story",
      "public_timestamp " => "2022-11-21T12:00:00.000+01:00",
    }
  end

  def stub_search_api_supergroup_request(group, organisation_slug, results)
    stub_supergroup_request(
      results: results,
      additional_params: {
        filter_content_purpose_supergroup: group,
        filter_organisations: organisation_slug,
        order: Search::Supergroup::DEFAULT_SORT_ORDER,
      }.merge(Search::Supergroups::SUPERGROUP_ADDITIONAL_SEARCH_PARAMS.fetch(group, {})),
    )
  end
end
