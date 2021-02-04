require "test_helper"

describe Search::Supergroups do
  include OrganisationHelpers

  before :each do
    content_item = ContentItem.new(organisation_with_featured_documents)
    empty_organisation = Organisation.new(content_item)

    content_item = ContentItem.new(organisation_with_translations)
    organisation = Organisation.new(content_item)

    @supergroups = described_class.new(organisation: organisation)
    @no_docs_supergroups = described_class.new(organisation: empty_organisation)

    Search::Supergroups::SUPERGROUP_TYPES.each do |supergroup|
      stub_search_api_supergroup_request(supergroup, organisation, [raw_search_api_result])
      stub_search_api_supergroup_request(supergroup, empty_organisation, [])
    end
  end

  describe "#has_groups?" do
    it "returns false if no groups have documents" do
      assert_equal false, @no_docs_supergroups.has_groups?
    end

    it "returns true if at least one supergroup has documents" do
      assert_equal true, @supergroups.has_groups?
    end
  end

  describe "#groups" do
    it "returns an array of supergroups" do
      assert_instance_of Search::Supergroup, @supergroups.groups.first
    end

    it "returns an array of supergroups regardless of doc responses" do
      assert_equal @supergroups.groups.map(&:content_purpose_supergroup), @no_docs_supergroups.groups.map(&:content_purpose_supergroup)
    end

    it "applies the given additional search parameters" do
      @supergroups.groups.each do |group|
        params = Search::Supergroups::SUPERGROUP_ADDITIONAL_SEARCH_PARAMS.fetch(
          group.content_purpose_supergroup,
          {},
        )
        query = group.documents_query
        assert_equal query.merge(params), query
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

  def stub_search_api_supergroup_request(group, organisation, results)
    stub_supergroup_request(
      results: results,
      additional_params: {
        filter_content_purpose_supergroup: group,
        filter_organisations: organisation.slug,
        order: Search::Supergroup::DEFAULT_SORT_ORDER,
      }.merge(Search::Supergroups::SUPERGROUP_ADDITIONAL_SEARCH_PARAMS.fetch(group, {})),
    )
  end
end
