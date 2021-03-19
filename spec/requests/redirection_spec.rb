require "integration_spec_helper"

RSpec.describe "Redirection of encoded urls" do
  before do
    base_path = "/government/people/cornelius-fudge"
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: "person")
      .merge("base_path" => base_path)

    stub_content_store_has_item(base_path, content_item)
  end

  scenario "redirects to the unencoded paths" do
    get "/government%2Fpeople%2Fcornelius-fudge"

    expect(response).to have_http_status(:redirect)
    expect("http://www.example.com/government/people/cornelius-fudge").to eq(response.header["Location"])
  end

  scenario "ignores query strings" do
    get "/government%2Fpeople%2Fcornelius-fudge?associates=higgs%26mclaggen%2Fshacklebolt%26tonks"

    expect(response).to have_http_status(:redirect)
    expect("http://www.example.com/government/people/cornelius-fudge?associates=higgs%26mclaggen%2Fshacklebolt%26tonks").to eq(response.header["Location"])
  end
end
