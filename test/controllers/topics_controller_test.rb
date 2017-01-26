require "test_helper"

describe TopicsController do
  include ContentSchemaHelpers
  include RummagerHelpers

  describe "GET topic" do
    describe "with a valid topic slug" do
      before do
        content_store_has_item('/topic/oil-and-gas', content_schema_example(:topic, :topic))
      end

      it "sets expiry headers for 30 minutes" do
        get :show, topic_slug: "oil-and-gas"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET topic with an invalid sector tag" do
      content_store_does_not_have_item("/topic/oil-and-gas")
      get :show, topic_slug: "oil-and-gas"

      assert_equal 404, response.status
    end
  end
end
