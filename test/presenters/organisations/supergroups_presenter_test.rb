require "test_helper"

describe Organisations::SupergroupsPresenter do
  include SearchApiHelpers
  include OrganisationHelpers

  before :each do
    content_item = ContentItem.new(organisation_with_featured_documents)
    organisation = Organisation.new(content_item)
    @supergroups_presenter = described_class.new(organisation, exclude_metadata_for: %w[news_and_communications])

    content_item = ContentItem.new(organisation_with_no_documents)
    organisation = Organisation.new(content_item)
    @empty_supergroups_presenter = described_class.new(organisation)

    stub_empty_search_api_requests("org-with-no-docs")
    stub_search_api_latest_content_requests("attorney-generals-office")
  end

  def find_supergroup_by_name(name)
    @supergroups_presenter.latest_documents_by_supergroup.find do |group|
      group[:title] == name
    end
  end

  describe "#has_groups" do
    it "returns true if latest documents by supergroup exist for an organisation" do
      assert @supergroups_presenter.has_groups?
    end

    it "returns false if no latest documents by type exist for an organisation" do
      assert_equal false, @empty_supergroups_presenter.has_groups?
    end
  end

  describe "#latest_documents_by_supergroup" do
    it "formats news and communications correctly" do
      supergroup = find_supergroup_by_name("News and communications")
      document = supergroup[:documents][:items].first

      assert_equal "News and communications", supergroup[:title]
      assert_equal "attorney-generals-office", supergroup[:documents][:brand]

      assert_equal "Content item 1", document[:link][:text]
      assert_equal "/content-item-1", document[:link][:path]
      assert_nil document[:metadata]

      assert_equal "/search/news-and-communications?organisations[]=attorney-generals-office&parent=attorney-generals-office", supergroup[:finder_link][:path]
      assert_equal "See all news and communications", supergroup[:finder_link][:text]
    end

    it "formats latest transparency correctly" do
      transparency = find_supergroup_by_name("Transparency and freedom of information releases")
      document = transparency[:documents][:items].first

      assert_equal "Transparency and freedom of information releases", transparency[:title]
      assert_equal "attorney-generals-office", transparency[:documents][:brand]

      assert_equal "Content item 1", document[:link][:text]
      assert_equal "/content-item-1", document[:link][:path]
      assert_equal Date.parse(1.hour.ago.iso8601), document[:metadata][:public_updated_at]
      assert_equal "Transparency data", document[:metadata][:document_type]

      assert_equal "/search/transparency-and-freedom-of-information-releases?organisations[]=attorney-generals-office&parent=attorney-generals-office", transparency[:finder_link][:path]
      assert_equal "See all transparency and freedom of information releases", transparency[:finder_link][:text]
    end

    it "formats latest guidance_and_regulation correctly" do
      supergroup = find_supergroup_by_name("Guidance and regulation")
      document = supergroup[:documents][:items].first

      assert_equal "Guidance and regulation", supergroup[:title]
      assert_equal "attorney-generals-office", supergroup[:documents][:brand]

      assert_equal "Content item 1", document[:link][:text]
      assert_equal "/content-item-1", document[:link][:path]
      assert_equal Date.parse(1.hour.ago.iso8601), document[:metadata][:public_updated_at]
      assert_equal "Guide", document[:metadata][:document_type]

      assert_equal "/search/guidance-and-regulation?organisations[]=attorney-generals-office&parent=attorney-generals-office", supergroup[:finder_link][:path]
      assert_equal "See all guidance and regulation", supergroup[:finder_link][:text]
    end

    it "does not include document types for which there are no latest documents" do
      # If documents do not exist for a certain document type (e.g: statistics), we don't want
      # statistics to be included at all in the latest_documents_by_supergroup array. If the value were
      # [] or nil, this would break the layout as in_groups_of() treats [] or nil as an item in the group.

      # Services in our tests is stubbed to return no results.
      assert_equal 5, @supergroups_presenter.latest_documents_by_supergroup.length
    end
  end
end
