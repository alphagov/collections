require_relative '../test_helper'

describe TopicsController do
  include ContentSchemaHelpers

  describe "GET topic with a valid topic slug" do
    before do
      content_store_has_item('/topic/oil-and-gas', content_schema_example(:topic, :topic))
    end

    it "sets the correct slimmer headers" do
      get :show, topic_slug: "oil-and-gas"

      assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
    end

    it "sets expiry headers for 30 minutes" do
      get :show, topic_slug: "oil-and-gas"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end
  end

  it "returns a 404 status for GET topic with an invalid sector tag" do
    content_store_does_not_have_item("/topic/oil-and-gas")
    get :show, topic_slug: "oil-and-gas"

    assert_equal 404, response.status
  end

  describe "invalid slugs" do
    it "returns a cacheable 404 without calling content-store if the sector slug is invalid" do
      get :show, topic_slug: "this & that"

      assert_equal "404", response.code
      assert_equal "max-age=600, public",  response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentStore::CONTENT_STORE_ENDPOINT}})
    end
  end
end
