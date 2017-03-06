require 'test_helper'
require './test/support/custom_assertions.rb'

describe DocumentCollectionFetcher do
  describe '#fetch ' do
    it 'returns results' do
      assert(
        DocumentCollectionFetcher.guidance.count > 0,
        "There should be document collections available."
      )
    end

    it 'returns only valid data' do
      DocumentCollectionFetcher.guidance.each do |entry|
        assert_equal(
          %w(false true),
          [entry['surface_collection'], entry['surface_content']].uniq.map(&:to_s).sort,
          "The document collection #{entry['base_path']} is invalid. You can only enable 'surface_content' or 'surface_collection'."
        )
      end
    end
  end
end
