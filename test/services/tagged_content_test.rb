require 'test_helper'
require './test/support/custom_assertions.rb'

describe TaggedContent do
  describe '#fetch' do
    it 'returns the documents from search' do
      search_results = mock(documents: ['doc1'])

      RummagerSearch.stubs(:new).returns(search_results)

      assert(tagged_content.fetch, ['doc1'])
    end

    it 'starts from the first page' do
      assert_includes_params(start: 0)
    end

    it 'requests all results' do
      assert_includes_params(count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING)
    end

    it 'requests a limited number of fields' do
      assert_includes_params(fields: %w(title description link))
    end

    it 'orders the results by title' do
      assert_includes_params(order: 'title')
    end

    it 'filters the results by taxon' do
      assert_includes_params(filter_taxons: [taxon_content_id])
    end

    it 'filters out non-guidance content' do
      guidance_document_types = RummagerSearch::GUIDANCE_DOCUMENT_TYPES

      assert_includes_params(
        filter_content_store_document_type: guidance_document_types
      )
    end

    it 'filters out content that belongs to a document collection' do
      assert_includes_params(filter_document_collections: '_MISSING')
    end
  end

private

  def assert_includes_params(expected_params)
    search_results = mock(documents: %w(doc1 doc2))

    RummagerSearch.
      stubs(:new).
      with { |params| params.including?(expected_params) }.
      returns(search_results)

    assert_equal(tagged_content.fetch, %w(doc1 doc2))
  end

  def taxon_content_id
    'c3c860fc-a271-4114-b512-1c48c0f82564'
  end

  def tagged_content
    @tagged_content ||= TaggedContent.new(taxon_content_id)
  end
end
