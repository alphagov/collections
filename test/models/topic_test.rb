require 'test_helper'

describe Topic, '#build' do
  it 'retrieves information from the content api based on the sector tag' do
    content_api_client = mock()
    topic_slug = mock()
    response = mock()

    content_api_client.expects(:tag).with(topic_slug, "specialist_sector").
      returns(response)
    topic = Topic.new(content_api_client, topic_slug).build

    assert_instance_of Topic, topic
  end

  it 'returns nil if no information is found' do
    content_api_client = mock()
    topic_slug = mock()

    content_api_client.expects(:tag).with(topic_slug, "specialist_sector")
    topic = Topic.new(content_api_client, topic_slug).build

    assert_equal topic, nil
  end
end

describe Topic, '#child_tags' do
  it 'retrieves related content from the content api based on the topic slug' do
    content_api_client = mock()
    topic_slug = mock()
    response = mock()
    child_tags = mock()

    content_api_client.expects(:tag).with(topic_slug, "specialist_sector").
      returns(response)
    topic = Topic.new(content_api_client, topic_slug).build

    content_api_client.expects(:child_tags).with(
      "specialist_sector",
      topic_slug,
      sort: "alphabetical").
      returns(child_tags)

    assert_equal child_tags, topic.child_tags
  end
end

describe Topic, '#title' do
  it 'retrieves the title from the content api response' do
    content_api_client = mock()
    topic_slug = mock()
    response = mock()
    response.stubs(:title).returns('Example Title')

    content_api_client.expects(:tag).with(topic_slug, "specialist_sector").
      returns(response)
    topic = Topic.new(content_api_client, topic_slug).build

    assert_equal 'Example Title', topic.title
  end
end

describe Topic, '#description' do
  it 'retrieves the description from the content api response' do
    content_api_client = mock()
    topic_slug = mock()
    details = mock()
    details.stubs(:description).returns('Example description')
    response = mock()
    response.stubs(:details).returns(details)

    content_api_client.expects(:tag).with(topic_slug, "specialist_sector").
      returns(response)
    topic = Topic.new(content_api_client, topic_slug).build

    assert_equal 'Example description', topic.description
  end
end
