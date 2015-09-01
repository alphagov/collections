require 'integration_test_helper'

class MainstreamBrowsingTest < ActionDispatch::IntegrationTest
  test "that we can handle all examples" do
    # Add all examples to the content store and content api to allow pages to
    # request their parents and links.
    content_schema_examples_for(:mainstream_browse_page).each do |content_item|
      content_store_has_item(content_item['base_path'], content_item)

      slugs = content_item['base_path'].gsub('/browse/', '')
      stub_request(:get, "https://contentapi.test.gov.uk/with_tag.json?section=#{slugs}").
        to_return(body: JSON.dump(results: []))
    end

    content_schema_examples_for(:mainstream_browse_page).each do |content_item|
      get content_item['base_path']

      assert_response 200
    end
  end
end
