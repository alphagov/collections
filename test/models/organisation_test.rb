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

  describe '#has_logo?' do
    it 'returns true if logo attributes are present' do
      organisation = Organisation.new(
        logo_formatted_title: "some\ntitle",
        brand: 'ministry-of-blah',
        crest: 'single-identity'
      )
      assert(organisation.has_logo?)
    end

    it 'returns false if the crest is missing' do
      organisation = Organisation.new(
        logo_formatted_title: "some\ntitle",
        brand: 'ministry-of-blah',
        crest: ''
      )
      refute(organisation.has_logo?)
    end

    it 'returns false if the it is a custom logo' do
      organisation = Organisation.new(
        crest: 'custom',
        logo_url: '/logo.png'
      )
      refute(organisation.has_logo?)
    end
  end

  describe '#custom_logo?' do
    it 'returns true if the crest is "custom"' do
      organisation = Organisation.new(
        crest: 'custom',
        logo_url: '/logo.png'
      )
      assert(organisation.custom_logo?)
    end

    it 'returns false if the crest is not "custom"' do
      organisation = Organisation.new(
        crest: 'somethingelse',
        logo_url: '/logo.png'
      )
      refute(organisation.custom_logo?)
    end

    it 'returns false if the logo url is missing' do
      organisation = Organisation.new(
        crest: 'somethingelse'
      )
      refute(organisation.custom_logo?)
    end
  end
end
