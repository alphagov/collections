require 'test_helper'

describe FilterTaggedContent do
  describe '#valid?' do
    it 'is valid for an unknown document collection' do
      document = Document.new(
        content_store_document_type: 'document_collection',
        base_path: '/a-new-document-collection'
      )

      assert(
        FilterTaggedContent.new.valid?(document),
        "It should display document collections we have no record of"
      )
    end

    it 'is not valid for content tagged to an unknown document collection' do
      document = Document.new(
        'content_store_document_type' => 'guide',
        'title' => 'Content in document collection',
        'document_collections' => [{
          'link' => '/a-new-document-collection'
        }]
      )

      refute(
        FilterTaggedContent.new.valid?(document),
        "It should not show content items tagged to unknown document collections"
      )
    end

    it 'is not valid for a document collection that should not be surfaced' do
      document = Document.new(
        content_store_document_type: 'document_collection',
        base_path: '/government/collections/national-curriculum-assessments-information-for-parents'
      )

      refute(
        FilterTaggedContent.new.valid?(document),
        'It should not show a document collection that should not be surfaced'
      )
    end

    it 'should include a collection that should be surfaced' do
      document = Document.new(
        content_store_document_type: 'document_collection',
        base_path: '/government/collections/send-pathfinders'
      )

      assert(
        FilterTaggedContent.new.valid?(document),
        'It should be valid for document collections that should be surfaced'
      )
    end

    it 'should be valid for content tagged to a collection that should be surfaced' do
      document = Document.new(
        content_store_document_type: 'guide',
        title: 'Content in document collection',
        base_path: '/content-item-base-path',
        document_collections: [{
          'link' => '/government/collections/national-curriculum-assessments-information-for-parents'
        }]
      )

      assert(
        FilterTaggedContent.new.valid?(document),
        'It should be valid for content tagged to a collection that should be surfaced'
      )
    end

    it 'should not be valid for content tagged to a collection that should not be surfaced' do
      document = Document.new(
        content_store_document_type: 'guide',
        title: 'Content in document collection',
        document_collections: [{
          'link' => '/government/collections/send-pathfinders'
        }]
      )

      refute(
        FilterTaggedContent.new.valid?(document),
        'It should not be valid for content items tagged to a collection in the results'
      )
    end
  end
end
