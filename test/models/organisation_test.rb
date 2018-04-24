require 'test_helper'

describe Organisation do
  it 'returns the state of an organisation' do
    organisation = Organisation.new(
      organisation_state: 'live'
    )
    assert(organisation.live?)
  end

  it 'returns false if the state of an organisation is not live' do
    organisation = Organisation.new(
      organisation_state: 'closed'
    )
    refute(organisation.live?)
  end

  it 'returns true for has_logo? if logo attributes are present' do
    organisation = Organisation.new(
      logo_formatted_title: "some\ntitle",
      brand: 'ministry-of-blah',
      crest: 'single-identity'
    )
    assert(organisation.has_logo?)
  end

  it 'returns false for has_logo? if logo_formatted_title is missing' do
    organisation = Organisation.new(
      logo_formatted_title: "",
      brand: 'ministry-of-blah',
      crest: 'single-identity'
    )
    refute(organisation.has_logo?)
  end

  it 'returns false for has_logo? if brand is missing' do
    organisation = Organisation.new(
      logo_formatted_title: "some\ntitle",
      brand: '',
      crest: 'single-identity'
    )
    refute(organisation.has_logo?)
  end

  it 'returns false for has_logo? if crest is missing' do
    organisation = Organisation.new(
      logo_formatted_title: "some\ntitle",
      brand: 'ministry-of-blah',
      crest: ''
    )
    refute(organisation.has_logo?)
  end

  it 'returns true for custom_logo if crest is "custom"' do
    organisation = Organisation.new(
      crest: 'custom'
    )
    assert(organisation.custom_logo?)
  end

  it 'returns false for custom_logo if crest is not "custom"' do
    organisation = Organisation.new(
      crest: 'somethingelse'
    )
    refute(organisation.custom_logo?)
  end
end
