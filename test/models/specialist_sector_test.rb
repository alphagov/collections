require 'test_helper'

describe SpecialistSector, '#build' do
  it 'retrieves information from the content api based on the sector tag' do
    content_api_client = mock()
    sector_tag = mock()
    response = mock()

    content_api_client.expects(:tag).with(sector_tag, "specialist_sector").
      returns(response)
    specialist_sector = SpecialistSector.new(content_api_client, sector_tag).build

    assert_instance_of SpecialistSector, specialist_sector
  end

  it 'returns nil if no information is found' do
    content_api_client = mock()
    sector_tag = mock()

    content_api_client.expects(:tag).with(sector_tag, "specialist_sector")
    specialist_sector = SpecialistSector.new(content_api_client, sector_tag).build

    assert_equal specialist_sector, nil
  end
end

describe SpecialistSector, '#child_tags' do
  it 'retrieves related content from the content api based on the sector tag' do
    content_api_client = mock()
    sector_tag = mock()
    response = mock()
    child_tags = mock()

    content_api_client.expects(:tag).with(sector_tag, "specialist_sector").
      returns(response)
    specialist_sector = SpecialistSector.new(content_api_client, sector_tag).build

    content_api_client.expects(:child_tags).with(
      "specialist_sector",
      sector_tag,
      sort: "alphabetical").
      returns(child_tags)

    assert_equal child_tags, specialist_sector.child_tags
  end
end

describe SpecialistSector, '#title' do
  it 'retrieves the title from the content api response' do
    content_api_client = mock()
    sector_tag = mock()
    response = mock()
    response.stubs(:title).returns('Example Title')

    content_api_client.expects(:tag).with(sector_tag, "specialist_sector").
      returns(response)
    specialist_sector = SpecialistSector.new(content_api_client, sector_tag).build

    assert_equal 'Example Title', specialist_sector.title
  end
end

describe SpecialistSector, '#description' do
  it 'retrieves the description from the content api response' do
    content_api_client = mock()
    sector_tag = mock()
    details = mock()
    details.stubs(:description).returns('Example description')
    response = mock()
    response.stubs(:details).returns(details)

    content_api_client.expects(:tag).with(sector_tag, "specialist_sector").
      returns(response)
    specialist_sector = SpecialistSector.new(content_api_client, sector_tag).build

    assert_equal 'Example description', specialist_sector.description
  end
end
