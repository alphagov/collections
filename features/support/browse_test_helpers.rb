require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/content_store'

module BrowseTestHelpers
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::ContentStore

  def stub_detailed_guidance
    detailed_guidance = OpenStruct.new({
      title: 'Detailed guidance',
      content_with_tag: OpenStruct.new(web_url: 'http://example.com/browse/detailed-guidance')
    })
    mock_api = stub('guidance_api')
    Collections.services(:detailed_guidance_content_api, mock_api)
    results = stub("results", results: [detailed_guidance])
    mock_api.stubs(:sub_sections).returns(results)
  end

  def assert_can_see_linked_item(name)
    assert page.has_selector?('a', text: name)
  end
end

World(BrowseTestHelpers)
