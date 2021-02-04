require "test_helper"

describe TopicsController do
  include SearchApiHelpers

  describe "GET topic" do
    describe "with a valid topic slug" do
      before do
        stub_content_store_has_item("/topic/oil-and-gas", topic_example)
      end

      it "sets expiry headers for 30 minutes" do
        get :show, params: { topic_slug: "oil-and-gas" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET topic with an invalid sector tag" do
      stub_content_store_does_not_have_item("/topic/oil-and-gas")
      get :show, params: { topic_slug: "oil-and-gas" }

      assert_equal 404, response.status
    end
  end

  def topic_example
    GovukSchemas::Example.find("topic", example_name: "topic")
  end
end
