require "test_helper"
require "./test/support/custom_assertions.rb"

describe MostPopularContent do
  include SearchApiFields

  def most_popular_content
    @most_popular_content ||= MostPopularContent.new(
      content_id: taxon_content_id,
      filter_content_store_document_type: %w[detailed_guide guidance],
    )
  end

  def taxon_content_id
    "c3c860fc-a271-4114-b512-1c48c0f82564"
  end

  describe "#fetch" do
    it "returns the results from search" do
      search_results = {
        "results" => [
          { "title" => "Doc 1" },
          { "title" => "A Doc 2" },
        ],
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = most_popular_content.fetch
      assert_equal(results.count, 2)
    end

    it "starts from the first page" do
      assert_includes_params(start: 0) do
        most_popular_content.fetch
      end
    end

    it "requests five results by default" do
      assert_includes_params(count: 5) do
        most_popular_content.fetch
      end
    end

    it "requests a limited number of fields" do
      fields = SearchApiFields::TAXON_SEARCH_FIELDS

      assert_includes_params(fields: fields) do
        most_popular_content.fetch
      end
    end

    it "orders the results by popularity in descending order" do
      assert_includes_params(order: "-popularity") do
        most_popular_content.fetch
      end
    end

    it "scopes the results to the current taxon" do
      assert_includes_params(filter_part_of_taxonomy_tree: Array(taxon_content_id)) do
        most_popular_content.fetch
      end
    end

    it "filters content by the requested document types only" do
      assert_includes_params(filter_content_store_document_type: %w[detailed_guide guidance]) do
        most_popular_content.fetch
      end
    end
  end
end
