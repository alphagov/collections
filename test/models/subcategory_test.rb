require 'test_helper'

describe Subcategory, '#build' do
  it 'retrives information from the content api based on the tag_id' do
    content_api_client = mock()
    tag_id = mock()
    response = mock()

    content_api_client.expects(:tag).with(tag_id, "specialist_sector").
      returns(response)

    subcategory = Subcategory.new(content_api_client, tag_id).build

    assert_instance_of Subcategory, subcategory
  end

  it 'returns nil if the content api does no have any information' do
    content_api_client = mock()
    tag_id = mock()

    content_api_client.expects(:tag).with(tag_id, "specialist_sector")
    subcategory = Subcategory.new(content_api_client, tag_id).build

    assert_equal nil, subcategory
  end
end

describe Subcategory, '#description' do
  it 'returns the description from the content api response' do
    content_api_client = mock()
    tag_id = mock()
    details = mock()
    details.stubs(:description).returns("Example description")
    response = mock()
    response.stubs(:details).returns(details)

    content_api_client.expects(:tag).with(tag_id, "specialist_sector").
      returns(response)

    subcategory = Subcategory.new(content_api_client, tag_id).build

    assert_equal "Example description", subcategory.description
  end
end

describe Subcategory, '#parent' do
  it 'returns the parent sector from the content api response' do
    content_api_client = mock()
    tag_id = mock()
    response = mock()
    response.stubs(:parent).returns("Parent sector")

    content_api_client.expects(:tag).with(tag_id, "specialist_sector").
      returns(response)

    subcategory = Subcategory.new(content_api_client, tag_id).build

    assert_equal "Parent sector", subcategory.parent
  end
end

describe Subcategory, '#parent_sector_title' do
  it 'returns the title for the parent sector' do
    content_api_client = mock()
    tag_id = mock()
    parent = mock()
    parent.stubs(:title).returns("Parent sector title")
    response = mock()
    response.stubs(:parent).returns(parent)

    content_api_client.expects(:tag).with(tag_id, "specialist_sector").
      returns(response)
    subcategory = Subcategory.new(content_api_client, tag_id).build

    assert_equal "Parent sector title", subcategory.parent_sector_title
  end
end

describe Subcategory, '#related_content' do
  it 'retrieves related content from the content api based on the tag_id' do
    content_api_client = mock()
    tag_id = mock()
    response = mock()
    related_content = mock()

    content_api_client.expects(:tag).with(tag_id, "specialist_sector").
      returns(response)
    content_api_client.expects(:with_tag).with(tag_id, "specialist_sector").
      returns(related_content)

    subcategory = Subcategory.new(content_api_client, tag_id).build

    assert_equal related_content, subcategory.related_content
  end
end

describe Subcategory, '#title' do
  it 'returns the title from the content api response' do
    content_api_client = mock()
    tag_id = mock()
    response = mock()
    response.stubs(:title).returns("Example title")

    content_api_client.expects(:tag).with(tag_id, "specialist_sector").
      returns(response)
    subcategory = Subcategory.new(content_api_client, tag_id).build

    assert_equal 'Example title', subcategory.title
  end
end
