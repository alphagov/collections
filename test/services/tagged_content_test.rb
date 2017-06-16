require 'test_helper'
require './test/support/custom_assertions.rb'

describe TaggedContent do
  setup do
    DocumentCollectionFetcher
      .stubs(:guidance)
      .returns(
        [
          {
            "base_path" => "/government/collections/national-curriculum-assessments-information-for-parents",
            "surface_collection" => false,
            "surface_content" => true
          },
          {
            "base_path" => "/government/collections/send-pathfinders",
            "surface_collection" => true,
            "surface_content" => false
          },
        ]
      )
  end

  describe '#fetch' do
    it 'shows document collections not known' do
      search_results = {
        'results' => [{
          'content_store_document_type' => 'document_collection',
          'link' => '/a-new-document-collection'
        }]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_equal(
        1,
        results.count,
        'It should include the document collection in the results'
      )

      result = results.first
      assert_equal(
        result.base_path,
        '/a-new-document-collection',
        'It should match the document collection\'s base path'
      )
    end

    it 'does not show content tagged to an unknown document collection' do
      search_results = {
        'results' => [{
          'content_store_document_type' => 'guide',
          'title' => 'Content in document collection',
          'document_collections' => [{
            'link' => '/a-new-document-collection'
          }]
        }]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_empty(
        results,
        'It should not include the content item tagged to an unknown collection in the results'
      )
    end

    it 'does not include a collection that should not be surfaced' do
      search_results = {
        'results' => [{
          'content_store_document_type' => 'document_collection',
          'link' => '/government/collections/national-curriculum-assessments-information-for-parents'
        }]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_empty(
        results,
        'It should not include the document collection in the results'
      )
    end

    it 'should include a collection that should be surfaced' do
      search_results = {
        'results' => [{
          'content_store_document_type' => 'document_collection',
          'link' => '/government/collections/send-pathfinders'
        }]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_equal(
        1,
        results.count,
        'It should include the document collection in the results'
      )

      result = results.first
      assert_equal(
        result.base_path,
        '/government/collections/send-pathfinders',
        'It should match the document collection\'s base path'
      )
    end

    it 'should include content tagged to a collection that should be surfaced' do
      search_results = {
        'results' => [{
          'content_store_document_type' => 'guide',
          'title' => 'Content in document collection',
          'link' => '/content-item-base-path',
          'document_collections' => [{
            'link' => '/government/collections/national-curriculum-assessments-information-for-parents'
          }]
        }]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_equal(
        1,
        results.count,
        'It should include the content tagged to a collection in the results'
      )

      result = results.first
      assert_equal(
        result.base_path,
        '/content-item-base-path',
        'It should match the content item\'s base path'
      )
    end

    it 'should not include content tagged to a collection that should not be surfaced' do
      search_results = {
        'results' => [{
          'content_store_document_type' => 'guide',
          'title' => 'Content in document collection',
          'document_collections' => [{
            'link' => '/government/collections/send-pathfinders'
          }]
        }]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_empty(
        results,
        'It should not include the content item tagged to a collection in the results'
      )
    end

    it 'returns the results from search' do
      search_results = {
        'results' => [{
          'title' => 'Doc 1'
        }]
      }

      Services.rummager.stubs(:search).returns(search_results)

      results = tagged_content.fetch
      assert_equal(results.count, 1)
      assert_equal(results.first.title, 'Doc 1')
    end

    it 'starts from the first page' do
      assert_includes_params(start: 0) do
        tagged_content.fetch
      end
    end

    it 'requests all results' do
      assert_includes_params(count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING) do
        tagged_content.fetch
      end
    end

    it 'requests a limited number of fields' do
      expected_fields =
        %w(title description link document_collections content_store_document_type)

      assert_includes_params(fields: expected_fields) do
        tagged_content.fetch
      end
    end

    it 'orders the results by title' do
      assert_includes_params(order: 'title') do
        tagged_content.fetch
      end
    end

    it 'filters the results by taxon' do
      assert_includes_params(filter_taxons: [taxon_content_id]) do
        tagged_content.fetch
      end
    end

    it 'filters guidance content only' do
      assert_includes_params(filter_navigation_document_supertype: 'guidance') do
        tagged_content.fetch
      end
    end

    it 'allows multiple content_ids' do
      assert_includes_params(filter_taxons: ["test-content-id-one", "test-content-id-two"]) do
        TaggedContent.fetch(["test-content-id-one", "test-content-id-two"])
      end
    end
  end

private

  def taxon_content_id
    'c3c860fc-a271-4114-b512-1c48c0f82564'
  end

  def tagged_content
    @tagged_content ||= TaggedContent.new(taxon_content_id)
  end
end
