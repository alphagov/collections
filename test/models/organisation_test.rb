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
  end
end
