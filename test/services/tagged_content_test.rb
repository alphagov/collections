require "test_helper"
require "./test/support/custom_assertions.rb"

describe TaggedContent do
  describe "#fetch" do
    it "returns the results from search" do
      search_results = {
        "results" => [{
          "title" => "Doc 1",
        }],
      }

      Services.search_api.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_equal(results.count, 1)
      assert_equal(results.first.title, "Doc 1")
    end

    it "starts from the first page" do
      assert_includes_params(start: 0) do
        tagged_content.fetch
      end
    end

    it "requests all results" do
      assert_includes_params(count: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING) do
        tagged_content.fetch
      end
    end

    it "requests a limited number of fields" do
      expected_fields =
        %w[title description link content_store_document_type]

      assert_includes_params(fields: expected_fields) do
        tagged_content.fetch
      end
    end

    it "orders the results by title" do
      assert_includes_params(order: "title") do
        tagged_content.fetch
      end
    end

    it "filters the results by taxon" do
      assert_includes_params(filter_taxons: [taxon_content_id]) do
        tagged_content.fetch
      end
    end

    it "allows multiple content_ids" do
      assert_includes_params(filter_taxons: %w[test-content-id-one test-content-id-two]) do
        TaggedContent.fetch(%w[test-content-id-one test-content-id-two])
      end
    end
  end

private

  def taxon_content_id
    "c3c860fc-a271-4114-b512-1c48c0f82564"
  end

  def tagged_content
    @tagged_content ||= TaggedContent.new(taxon_content_id)
  end
end
