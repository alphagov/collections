require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/content_store'

module BrowseTestHelpers
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::ContentStore

  def stub_browse_sections(section: nil, sub_section: nil, artefact: nil,
                           organisations: [])
    sub_section_slug = [section, sub_section].join('/')
    content_api_has_tag("section", section)
    content_api_has_tag("section", sub_section_slug)
    content_api_has_root_tags("section", [section])
    content_api_has_child_tags("section", section, [sub_section_slug])
    content_api_has_artefacts_with_a_tag("section", sub_section_slug, [artefact])
  end

  def stub_detailed_guidance
    detailed_guidance = OpenStruct.new({
      title: 'Detailed guidance',
      content_with_tag: OpenStruct.new(web_url: 'http://example.com/browse/detailed-guidance')
    })
    mock_api = stub('guidance_api')
    Collections.services(:detailed_guidance_content_api, mock_api)
    results = stub("results", results: [detailed_guidance])
    mock_api.stubs(:sub_sections).returns(results)

    content_store_has_item '/browse/crime-and-justice/judges', { links: {} }
  end

  def stub_404_detailed_guidance_response
    stub_request(:get, "#{Plek.current.find('whitehall-admin')}/api/specialist/tags.json?parent_id=crime-and-justice/judges&type=section").to_raise(GdsApi::HTTPNotFound)

    content_store_has_item '/browse/crime-and-justice/judges', { links: {} }
  end

  def browse_to_sub_section(section: nil, sub_section: nil)
    visit browse_path
    click_link section
    click_link sub_section
  end

  def assert_can_see_linked_item(name)
    assert page.has_selector?('a', text: name)
  end
end

World(BrowseTestHelpers)
