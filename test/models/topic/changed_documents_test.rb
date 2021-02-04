require "test_helper"

describe Topic::ChangedDocuments do
  include SearchApiHelpers

  describe "with a single page of results available" do
    setup do
      @subtopic_content_id = "paye-content-id"
      search_api_has_latest_documents_for_subtopic(
        @subtopic_content_id,
        %w[
          pay-paye-penalty
          pay-paye-tax
          pay-psa
          employee-tax-codes
          payroll-annual-reporting
        ],
      )
    end

    it "returns the latest documents for the subtopic" do
      expected_titles = [
        "Pay paye penalty",
        "Pay paye tax",
        "Pay psa",
        "Employee tax codes",
        "Payroll annual reporting",
      ]

      assert_equal expected_titles, Topic::ChangedDocuments.new(@subtopic_content_id).map(&:title)
    end

    it "provides the title, base_path and change_note for each document" do
      documents = Topic::ChangedDocuments.new(@subtopic_content_id).to_a

      # Actual values come from rummager helpers.
      assert_equal "/pay-psa", documents[2].base_path
      assert_equal "Employee tax codes", documents[3].title
      assert_equal "This has changed", documents[4].change_note
    end

    it "provides the public_updated_at for each document" do
      documents = Topic::ChangedDocuments.new(@subtopic_content_id).to_a

      assert documents[0].public_updated_at.is_a?(Time)

      # Document timestamp value set in rummager helpers
      assert_in_epsilon 1.hour.ago.to_i, documents[0].public_updated_at.to_i, 5
    end
  end

  describe "with multiple pages of results available" do
    setup do
      @subtopic_content_id = "paye-content-id"
      search_api_has_latest_documents_for_subtopic(
        @subtopic_content_id,
        %w[
          pay-paye-penalty
          pay-paye-tax
          pay-psa
          employee-tax-codes
          payroll-annual-reporting
        ],
        page_size: 3,
      )
      @pagination_options = { count: 3 }
      @documents = Topic::ChangedDocuments.new(@subtopic_content_id, @pagination_options)
    end

    it "returns the first page of results" do
      expected_titles = [
        "Pay paye penalty",
        "Pay paye tax",
        "Pay psa",
      ]
      assert_equal expected_titles, @documents.map(&:title)
    end

    it "returns the requested page of results" do
      @pagination_options[:start] = 3
      expected_titles = [
        "Employee tax codes",
        "Payroll annual reporting",
      ]
      assert_equal expected_titles, @documents.map(&:title)
    end
  end

  describe "handling missing fields in the search results" do
    it "handles documents that don't contain the public_timestamp field" do
      result = search_api_document_for_slug("pay-psa")
      result.delete("public_timestamp")

      Services.search_api.stubs(:search).with(
        has_entries(filter_topic_content_ids: %w[paye-content-id]),
      ).returns("results" => [result],
                "start" => 0,
                "total" => 1)

      documents = Topic::ChangedDocuments.new("paye-content-id")

      assert_equal 1, documents.to_a.size
      assert_equal "Pay psa", documents.first.title
      assert_nil documents.first.public_updated_at
    end
  end
end
