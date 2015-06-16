require "test_helper"

def build_mock_collections_api
  stub('CollectionsApi').tap {|api|
    Collections.services(:collections_api, api)
  }
end

describe Subtopic, ".find" do
  it "finds the curated content for the given slug in the collections api" do
    slug = "oil-and-gas/wells"
    collections_api_has_content_for("/#{slug}")

    subtopic = Subtopic.find(slug)

    assert_instance_of Subtopic, subtopic
    assert subtopic.groups
    assert subtopic.changed_documents
  end

  it "returns nil if there is no content for the given slug in the collections api" do
    slug = "nothing-here"
    collections_api_has_no_content_for("/#{slug}")

    subtopic = Subtopic.find(slug)

    assert_equal nil, subtopic
  end

  it 'passes the "start" and "count" arguments to the API request' do
    mock_collections_api = stub("CollectionsApi")
    mock_response = stub("Response", title: 'Foo')
    Collections.services(:collections_api, mock_collections_api)

    mock_collections_api.expects(:topic)
                        .with('/foo', has_entries(start: 10, count: 30))
                        .returns(mock_response)

    subtopic = Subtopic.find('foo', start: 10, count: 30)

    assert_equal 'Foo', subtopic.title
  end
end

describe Subtopic, "#groups" do
  it "returns the curated content for the subtopic" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_content_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subtopic = Subtopic.find(slug)

    assert_equal stubbed_response_body['details']['groups'][0]['name'], subtopic.groups.first.name
  end
end

describe Subtopic, "#changed_documents" do
  it "returns the changed documents for the subtopic" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_content_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subtopic = Subtopic.find(slug)

    assert_equal stubbed_response_body['details']['documents'][0]['title'], subtopic.changed_documents.first.title
  end
end

describe Subtopic, "#description" do
  it "returns the description for the subtopic" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_content_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subtopic = Subtopic.find(slug)

    assert_equal stubbed_response_body['description'], subtopic.description
  end
end

describe Subtopic, "#title" do
  it "returns the title for the subtopic" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_content_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subtopic = Subtopic.find(slug)

    assert_equal stubbed_response_body['title'], subtopic.title
  end
end

describe Subtopic, "#parent_topic_title" do
  it "returns the topic for the subtopic" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_content_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subtopic = Subtopic.find(slug)

    assert_equal stubbed_response_body['parent']['title'], subtopic.parent_topic_title
  end
end

describe Subtopic, "#combined_title" do
  it "combined the parent and child titles for added context" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_content_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subtopic = Subtopic.find(slug)

    expected_combined_title = "#{stubbed_response_body['parent']['title']}: #{stubbed_response_body['title']}"
    assert_equal expected_combined_title, subtopic.combined_title
  end
end

describe Subtopic, "#slug" do
  it "returns the slug for the subtopic" do
    slug = "oil-and-gas/wells"
    collections_api_has_content_for("/#{slug}")

    subtopic = Subtopic.find(slug)

    assert_equal slug, subtopic.slug
  end
end

describe Subtopic, '#documents_total' do
  it 'returns the total number of documents for the subtopic' do
    mock_collections_api = build_mock_collections_api
    mock_response = stub("Response", details: stub('Details', documents_total: 2560))

    mock_collections_api.expects(:topic).with('/foo', {}).returns(mock_response)

    subtopic = Subtopic.find('foo')

    assert_equal 2560, subtopic.documents_total
  end
end

describe Subtopic, '#documents_start' do
  it 'returns the starting offset for the recent documents in the subtopic' do
    mock_collections_api = build_mock_collections_api
    mock_response = stub('Response', details: stub('Details', documents_start: 42))

    mock_collections_api.expects(:topic).with('/foo', {}).returns(mock_response)

    subtopic = Subtopic.find('foo')

    assert_equal 42, subtopic.documents_start
  end
end

describe Subtopic, '#parent_slug' do
  it 'returns the parent portion of the slug for the subtopic' do
    slug = 'oil-and-gas/fields-and-wells'
    collections_api_has_content_for("/#{slug}")

    subtopic = Subtopic.find(slug)

    assert_equal 'oil-and-gas', subtopic.parent_slug
  end
end

describe Subtopic, '#child_slug' do
  it 'returns the child portion of the slug for the subtopic' do
    slug = 'oil-and-gas/fields-and-wells'
    collections_api_has_content_for("/#{slug}")

    subtopic = Subtopic.find(slug)

    assert_equal 'fields-and-wells', subtopic.child_slug
  end
end
