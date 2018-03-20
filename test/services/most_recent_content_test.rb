require "test_helper"

describe MostRecentContent do
  def most_recent_content
    @most_recent_content ||= MostRecentContent.new(
      content_id: taxon_content_id,
      filter_content_purpose_supergroup: "news_and_communications",
    )
  end

  def taxon_content_id
    "a18d16c4-29ff-41c2-a667-022f7615ba49"
  end

  describe "#fetch" do
    it "returns the results from search" do
      search_results = {
        "results" => [
          { "title" => "First news story" },
          { "title" => "Second news story" },
          { "title" => "Third news story" },
          { "title" => "Fourth news story" },
          { "title" => "Fifth news story" }
        ]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = most_recent_content.fetch
      assert_equal(results.count, 5)
    end
  end

  it "starts from the first page" do
    assert_includes_params(start: 0) do
      most_recent_content.fetch
    end
  end

  it "requests five results by default" do
    assert_includes_params(count: 5) do
      most_recent_content.fetch
    end
  end

  it "requests a limited number of fields" do
    fields = %w(title
                link
                content_store_document_type
                public_timestamp
                organisations)

    assert_includes_params(fields: fields) do
      most_recent_content.fetch
    end
  end

  it "orders the results by public_timestamp in descending order" do
    assert_includes_params(order: '-public_timestamp') do
      most_recent_content.fetch
    end
  end

  it "scopes the results to the current taxon" do
    assert_includes_params(filter_taxons: [taxon_content_id]) do
      most_recent_content.fetch
    end
  end

  it "filters content by the requested filter_content_purpose_supergroup only" do
    assert_includes_params(filter_content_purpose_supergroup: "news_and_communications") do
      most_recent_content.fetch
    end
  end
end
