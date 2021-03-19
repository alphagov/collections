RSpec.describe Organisations::SupergroupsPresenter do
  include SearchApiHelpers
  include OrganisationHelpers

  let(:supergroups_presenter) { presenter_from_organisation_hash(organisation_with_featured_documents, exclude_metadata_for: %w[news_and_communications]) }
  let(:empty_supergroups_presenter) { presenter_from_organisation_hash(organisation_with_no_documents) }

  before do
    stub_empty_search_api_requests("org-with-no-docs")
    stub_search_api_latest_content_requests("attorney-generals-office")
  end

  def find_supergroup_by_name(name)
    supergroups_presenter.latest_documents_by_supergroup.find do |group|
      group[:title] == name
    end
  end

  def presenter_from_organisation_hash(content, exclude_metadata_for: nil)
    content_item = ContentItem.new(content)
    organisation = Organisation.new(content_item)
    described_class.new(organisation, exclude_metadata_for: exclude_metadata_for)
  end

  describe "#has_groups" do
    it "returns true if latest documents by supergroup exist for an organisation" do
      expect(supergroups_presenter.has_groups?).to be true
    end

    it "returns false if no latest documents by type exist for an organisation" do
      expect(empty_supergroups_presenter.has_groups?).to eq(false)
    end
  end

  describe "#latest_documents_by_supergroup" do
    it "formats news and communications correctly" do
      supergroup = find_supergroup_by_name("News and communications")
      document = supergroup[:documents][:items].first

      expect(supergroup[:title]).to eq("News and communications")
      expect(supergroup[:documents][:brand]).to eq("attorney-generals-office")

      expect(document[:link][:text]).to eq("Content item 1")
      expect(document[:link][:path]).to eq("/content-item-1")
      expect(document[:metadata]).to be_nil

      expect(supergroup[:finder_link][:path]).to eq("/search/news-and-communications?organisations[]=attorney-generals-office&parent=attorney-generals-office")
      expect(supergroup[:finder_link][:text]).to eq("See all news and communications")
    end

    it "formats latest transparency correctly" do
      transparency = find_supergroup_by_name("Transparency and freedom of information releases")
      document = transparency[:documents][:items].first

      expect(transparency[:title]).to eq("Transparency and freedom of information releases")
      expect(transparency[:documents][:brand]).to eq("attorney-generals-office")

      expect(document[:link][:text]).to eq("Content item 1")
      expect(document[:link][:path]).to eq("/content-item-1")
      expect(document[:metadata][:public_updated_at]).to eq(Date.parse(1.hour.ago.iso8601))
      expect(document[:metadata][:document_type]).to eq("Transparency data")

      expect(transparency[:finder_link][:path]).to eq("/search/transparency-and-freedom-of-information-releases?organisations[]=attorney-generals-office&parent=attorney-generals-office")
      expect(transparency[:finder_link][:text]).to eq("See all transparency and freedom of information releases")
    end

    it "formats latest guidance_and_regulation correctly" do
      supergroup = find_supergroup_by_name("Guidance and regulation")
      document = supergroup[:documents][:items].first

      expect(supergroup[:title]).to eq("Guidance and regulation")
      expect(supergroup[:documents][:brand]).to eq("attorney-generals-office")

      expect(document[:link][:text]).to eq("Content item 1")
      expect(document[:link][:path]).to eq("/content-item-1")
      expect(document[:metadata][:public_updated_at]).to eq(Date.parse(1.hour.ago.iso8601))
      expect(document[:metadata][:document_type]).to eq("Guide")

      expect(supergroup[:finder_link][:path]).to eq("/search/guidance-and-regulation?organisations[]=attorney-generals-office&parent=attorney-generals-office")
      expect(supergroup[:finder_link][:text]).to eq("See all guidance and regulation")
    end

    it "does not include document types for which there are no latest documents" do
      # If documents do not exist for a certain document type (e.g: statistics), we don't want
      # statistics to be included at all in the latest_documents_by_supergroup array. If the value were
      # [] or nil, this would break the layout as in_groups_of() treats [] or nil as an item in the group.

      # Services in our tests is stubbed to return no results.
      expect(supergroups_presenter.latest_documents_by_supergroup.length).to eq(5)
    end
  end
end
