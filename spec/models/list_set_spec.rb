RSpec.describe ListSet do
  include SearchApiHelpers
  context "for a curated subtopic" do
    let(:group_data) do
      [
        {
          "name" => "Paying HMRC",
          "contents" => [
            "/pay-paye-tax",
            "/pay-psa",
            "/pay-paye-penalty",
          ],
          "content_ids" => %w[
            pay-paye-tax-content-id
            pay-psa-content-id
            pay-paye-penalty-content-id
          ],
        },
        {
          "name" => "Annual PAYE and payroll tasks",
          "contents" => [
            "/payroll-annual-reporting",
            "/get-paye-forms-p45-p60",
            "/employee-tax-codes",
          ],
          "content_ids" => %w[
            payroll-annual-reporting-content-id
            get-paye-forms-p45-p60-content-id
            employee-tax-codes-content-id
          ],
        },
      ]
    end

    let(:list_set) { described_class.new("specialist_sector", "paye-content-id", group_data) }

    before do
      search_api_has_documents_for_subtopic(
        "paye-content-id",
        %w[
          employee-tax-codes
          get-paye-forms-p45-p60
          pay-paye-penalty
          pay-paye-tax
          pay-psa
          payroll-annual-reporting
        ],
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )
    end

    it "returns the groups in the curated order" do
      expect(list_set.map(&:title)).to eq(["Paying HMRC", "Annual PAYE and payroll tasks"])
    end

    it "provides the title and base_path for group items" do
      groups = list_set.to_a

      expect(groups[1].contents.to_a[2].title).to eq("Employee tax codes")
      expect(groups[0].contents.to_a[1].base_path).to eq("/pay-psa")
    end

    it "skips items no longer tagged to this subtopic" do
      group_data[0]["contents"] << "/pay-bear-tax"

      groups = list_set.to_a
      expect(groups[0].contents.size).to eq(3)
      expect(groups[0]["contents"].map(&:base_path)).not_to include("/pay-bear-tax")
    end

    it "omits groups with no active items in them" do
      group_data << {
        "name" => "Group with untagged items",
        "contents" => [
          "/pay-bear-tax",
        ],
        "content_ids" => %w[
          pay-bear-tax-content-id
        ],
      }
      group_data << {
        "name" => "Empty group",
        "contents" => [],
        "content_ids" => [],
      }

      expect(list_set.count).to eq(2)
      list_titles = list_set.map(&:title)
      expect(list_titles).not_to include("Group with untagged items")
      expect(list_titles).not_to include("Empty group")
    end
  end

  context "for a non-curated topic" do
    let(:list_set_empty_data) { described_class.new("specialist_sector", "paye-content-id", []) }
    let(:list_set_nil_data) { described_class.new("specialist_sector", "paye-content-id", nil) }

    before do
      search_api_has_documents_for_subtopic(
        "paye-content-id",
        %w[
          get-paye-forms-p45-p60
          pay-paye-penalty
          pay-paye-tax
          pay-psa
          employee-tax-codes
          payroll-annual-reporting
        ],
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )
    end

    it "constructs a single A-Z group" do
      expect(list_set_empty_data.to_a.size).to eq(1)
      expect(list_set_empty_data.first.title).to eq("A to Z")
    end

    it "includes content tagged to the topic in alphabetical order" do
      expected_titles = [
        "Employee tax codes",
        "Get paye forms p45 p60",
        "Pay paye penalty",
        "Pay paye tax",
        "Pay psa",
        "Payroll annual reporting",
      ]
      expect(list_set_empty_data.first.contents.map(&:title)).to eq(expected_titles)
    end

    it "includes the base_path for all items" do
      expect(list_set_empty_data.first.contents.to_a[3].base_path).to eq("/pay-paye-tax")
    end

    it "handles nil data the same as empty array" do
      expect(list_set_nil_data.to_a.size).to eq(1)
      expect(list_set_nil_data.first.title).to eq("A to Z")
    end
  end

  describe "fetching content tagged to this tag" do
    let(:list_set) { described_class.new("specialist_sector", "paye-content-id") }

    before do
      search_api_has_documents_for_subtopic("paye-content-id",
                                            %w[
                                              pay-paye-penalty
                                              pay-paye-tax
                                              pay-psa
                                              employee-tax-codes
                                              payroll-annual-reporting
                                            ],
                                            page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)
    end

    it "returns the content for the tag" do
      expected_titles = [
        "Pay paye penalty",
        "Pay paye tax",
        "Pay psa",
        "Employee tax codes",
        "Payroll annual reporting",
      ]
      titles = list_set.first.contents.map(&:title).sort
      expect(titles).to eq(expected_titles.sort)
    end

    it "provides the title, base_path for each document" do
      documents = list_set.first.contents

      expect(documents[2].base_path).to eq("/pay-paye-tax")
      expect(documents[2].title).to eq("Pay paye tax")
    end
  end

  describe "handling missing fields in the search results" do
    let(:list_set) { described_class.new("specialist_sector", "paye-content-id") }
    it "handles documents that don't contain the public_timestamp field" do
      result = search_api_document_for_slug("pay-psa")
      result.delete("public_timestamp")

      params = {
        "filter_topic_content_ids" => %w[paye-content-id],
      }
      body = {
        "results" => [result],
        "start" => 0,
        "total" => 1,
      }

      stub_search(params:, body:)

      documents = list_set.first.contents

      expect(documents.to_a.size).to eq(1)
      expect(documents.first.title).to eq("Pay psa")
      expect(documents.first.public_updated_at).to be_nil
    end
  end

  describe "filtering uncurated lists" do
    let(:list_set) { described_class.new("section", "content-id-for-living-abroad") }

    it "shouldn't display a document if its format is excluded" do
      search_api_has_documents_for_browse_page(
        "content-id-for-living-abroad",
        %w[baz],
        ListSet::BROWSE_FORMATS_TO_EXCLUDE.to_a.last,
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )

      expect(list_set.first.contents.length).to eq(0)
    end

    it "should display a document if its format isn't excluded" do
      search_api_has_documents_for_browse_page(
        "content-id-for-living-abroad",
        %w[baz],
        "some-format-not-excluded",
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )

      results = list_set.first.contents
      expect(results.length).to eq(1)
      expect(results.first.title).to eq("Baz")
    end
  end

  describe "for a curated subtopic, when document's slug changed" do
    let(:group_data) do
      [
        {
          "name" => "Paying HMRC",
          "contents" => [
            "/pay-paye-tax-old-base-path",
          ],
          "content_ids" => %w[
            pay-paye-tax-content-id
          ],
        },
      ]
    end

    before do
      search_api_has_documents_for_subtopic(
        "paye-content-id",
        %w[
          pay-paye-tax
        ],
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )
    end

    let(:list_set) { described_class.new("specialist_sector", "paye-content-id", group_data) }

    it "provides the title and new base_path for group items" do
      groups = list_set.to_a

      expect(groups.first.contents.first.base_path).to eq("/pay-paye-tax")
    end
  end
end
