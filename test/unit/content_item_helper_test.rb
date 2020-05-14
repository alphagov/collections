require "test_helper"

describe ContentItemHelper do
  setup do
    url = content_store_endpoint + "/content/blah/blah"
    stub_request(:get, url).to_return(status: 200, body: {
      description: "This is a description for a content item",
    }.to_json)
  end

  describe "#content_item_description" do
    it "returns description for content item" do
      assert_equal "This is a description for a content item", content_item_description("/blah/blah")
    end
  end
end
