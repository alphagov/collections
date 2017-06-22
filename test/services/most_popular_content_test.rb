require 'test_helper'
require './test/support/custom_assertions.rb'

describe MostPopularContent do
  def most_popular_content
    @most_popular_content ||= MostPopularContent.new(
      content_id: taxon_content_id,
      filter_by_document_supertype: 'guidance'
    )
  end

  def taxon_content_id
    'c3c860fc-a271-4114-b512-1c48c0f82564'
  end

  describe '#fetch' do
    it 'returns the results from search, sorted by title' do
      search_results = {
        'results' => [
          { 'title' => 'Doc 1' },
          { 'title' => 'A Doc 2' },
        ]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = most_popular_content.fetch
      assert_equal(results.count, 2)
      assert_equal(results.first.title, 'A Doc 2')
      assert_equal(results.last.title, 'Doc 1')
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
      assert_includes_params(fields: %w(title link)) do
        most_popular_content.fetch
      end
    end

    it 'orders the results by popularity in descending order' do
      assert_includes_params(order: '-popularity') do
        most_popular_content.fetch
      end
    end

    it 'scopes the results to the taxonomy tree under the given taxon' do
      assert_includes_params(filter_part_of_taxonomy_tree: taxon_content_id) do
        most_popular_content.fetch
      end
    end

    it 'filters content by the requested filter_by_document_supertype only' do
      assert_includes_params(filter_navigation_document_supertype: 'guidance') do
        most_popular_content.fetch
      end
    end
  end
end
