require 'test_helper'
require './test/support/custom_assertions.rb'

describe MostPopularContent do
  def most_popular_content
    @most_popular_content ||= MostPopularContent.new(
      content_id: taxon_content_id,
      filter_content_purpose_supergroup: 'guidance_and_regulation'
    )
  end

  def taxon_content_id
    'c3c860fc-a271-4114-b512-1c48c0f82564'
  end

  describe '#fetch' do
    it 'returns the results from search' do
      search_results = {
        'results' => [
          { 'title' => 'Doc 1' },
          { 'title' => 'A Doc 2' },
        ]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = most_popular_content.fetch
      assert_equal(results.count, 2)
    end

    it 'starts from the first page' do
      assert_includes_params(start: 0) do
        most_popular_content.fetch
      end
    end

    it 'requests five results by default' do
      assert_includes_params(count: 5) do
        most_popular_content.fetch
      end
    end

    it 'requests a limited number of fields' do
      fields = %w(title
                  link
                  description
                  content_store_document_type
                  public_timestamp
                  organisations)

      assert_includes_params(fields: fields) do
        most_popular_content.fetch
      end
    end

    it 'orders the results by popularity in descending order' do
      assert_includes_params(order: '-popularity') do
        most_popular_content.fetch
      end
    end

    it 'scopes the results to the current taxon' do
      assert_includes_params(filter_taxons: Array(taxon_content_id)) do
        most_popular_content.fetch
      end
    end

    it 'filters content by the requested filter_content_purpose_supergroup only' do
      assert_includes_params(filter_content_purpose_supergroup: 'guidance_and_regulation') do
        most_popular_content.fetch
      end
    end
  end
end
