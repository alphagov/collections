require 'integration_test_helper'

class MainstreamBrowsingTest < ActionDispatch::IntegrationTest
  test "that we can handle all examples" do
    content_schema_examples_for(:mainstream_browse_page).each do |content_item|
      stub_other_requests(content_item)
      content_store_has_item(content_item['base_path'], content_item)

      get content_item['base_path']

      assert_response 200
    end
  end

  private

  def stub_other_requests(content_item)
    _, _, section, sub_section = content_item['base_path'].split('/')
    sub_section_slug = [section, sub_section].join('/')
    content_api_has_tag("section", section)
    content_api_has_tag("section", sub_section_slug)
    content_api_has_root_tags("section", [section])
    content_api_has_child_tags("section", section, [sub_section_slug])
    content_api_has_artefacts_with_a_tag("section", sub_section_slug, [])

    RelatedTopicList.any_instance.stubs(:legacy_fallback_to_whitehall).returns([])
  end
end
