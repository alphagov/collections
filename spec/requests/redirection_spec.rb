require "integration_test_helper"

class RedirectionTest < ActionDispatch::IntegrationTest
  describe "URL encoded paths" do
    before do
      base_path = "/government/people/cornelius-fudge"
      content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: "person")
        .merge("base_path" => base_path)

      stub_content_store_has_item(base_path, content_item)
    end

    it "redirects to their unencoded paths" do
      get "/government%2Fpeople%2Fcornelius-fudge"

      expect(response).to be_redirect
      expect("http://www.example.com/government/people/cornelius-fudge").to eq(response.header.[]("Location"))
    end

    it "ignores query strings" do
      get "/government%2Fpeople%2Fcornelius-fudge?associates=higgs%26mclaggen%2Fshacklebolt%26tonks"

      expect(response).to be_redirect
      expect("http://www.example.com/government/people/cornelius-fudge?associates=higgs%26mclaggen%2Fshacklebolt%26tonks").to eq(response.header.[]("Location"))
    end
  end
end
