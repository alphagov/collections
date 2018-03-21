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
end
