RSpec.describe Topic::ChangedDocuments do
  include SearchApiHelpers

  def subtopic_content_id
    "paye-content-id"
  end

  def titles
    [
      "Pay paye penalty",
      "Pay paye tax",
      "Pay psa",
      "Employee tax codes",
      "Payroll annual reporting",
    ]
  end

  def document_slugs
    titles.map(&:parameterize)
  end

  describe "with a single page of results available" do
    before do
      search_api_has_latest_documents_for_subtopic(subtopic_content_id, document_slugs)
    end

    subject { described_class.new(subtopic_content_id) }
    let(:documents) { subject.to_a }

    it "returns the latest documents for the subtopic" do
      expect(subject.map(&:title)).to eq(titles)
    end

    it "provides the title, base_path and change_note for each document" do
      # Actual values come from search_api helpers.
      assert_equal "/pay-psa", documents[2].base_path
      assert_equal "Employee tax codes", documents[3].title
      assert_equal "This has changed", documents[4].change_note
    end

    it "provides the public_updated_at for each document" do
      expect(documents[0].public_updated_at).to be_kind_of(Time)

      # Document timestamp value set in search_api helpers
      expect(documents[0].public_updated_at.to_i).to be_within(5).of(1.hour.ago.to_i)
    end
  end

  describe "with multiple pages of results available" do
    before do
      search_api_has_latest_documents_for_subtopic(subtopic_content_id, document_slugs, page_size: 3)
    end

    let(:pagination_options) { { count: 3 } }
    subject { described_class.new(subtopic_content_id, pagination_options) }

    it "returns the first page of results" do
      expect(subject.map(&:title)).to eq(titles.first(3))
    end

    it "returns the requested page of results" do
      pagination_options[:start] = 3
      expect(subject.map(&:title)).to eq(titles.last(2))
    end
  end

  describe "handling missing fields in the search results" do
    it "handles documents that don't contain the public_timestamp field" do
      result = search_api_document_for_slug("pay-psa")
      result.delete("public_timestamp")
      params = { filter_topic_content_ids: %w[paye-content-id] }
      body = { "results" => [result],
               "start" => 0,
               "total" => 1 }
      stub_search(params:, body:)

      subject = described_class.new(subtopic_content_id)

      expect(subject.to_a.size).to eq 1
      expect(subject.first.title).to eq("Pay psa")
      expect(subject.first.public_updated_at).to be_nil
    end
  end
end
