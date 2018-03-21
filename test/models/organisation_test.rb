require 'test_helper'

describe Organisation do
  it 'returns the state of an organisation' do
    organisation = Organisation.new(
      title: 'Organisation Title',
      content_id: '12345',
      link: '/organisation/link',
      slug: 'slug',
      organisation_state: 'live',
      document_count: 100
    )
    assert(organisation.live?)
  end
end
