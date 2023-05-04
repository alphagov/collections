RSpec.describe "Redirection of encoded urls" do
  before do
    base_path = "/government/people/cornelius-fudge"
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: "person")
      .merge("base_path" => base_path)

    stub_content_store_has_item(base_path, content_item)
  end

  it "redirects to the unencoded paths" do
    get "/government%2Fpeople%2Fcornelius-fudge"

    expect(response).to have_http_status(:redirect)
    expect("http://www.example.com/government/people/cornelius-fudge").to eq(response.header["Location"])
  end

  it "ignores query strings" do
    get "/government%2Fpeople%2Fcornelius-fudge?associates=higgs%26mclaggen%2Fshacklebolt%26tonks"

    expect(response).to have_http_status(:redirect)
    expect("http://www.example.com/government/people/cornelius-fudge?associates=higgs%26mclaggen%2Fshacklebolt%26tonks").to eq(response.header["Location"])
  end

  it "redirects organisation chiefs-of-staff path to the organisation path" do
    get "/government/organisations/organisation-1/chiefs-of-staff"

    expect(response).to redirect_to("/government/organisations/organisation-1")
  end

  it "redirects organisation consultations path to the organisation path" do
    get "/government/organisations/organisation-1/consultations"

    expect(response).to redirect_to("/government/organisations/organisation-1")
  end

  it "redirects organisation groups path to the organisation path" do
    get "/government/organisations/organisation-1/groups"

    expect(response).to redirect_to("/government/organisations/organisation-1")
  end

  it "redirects organisation group path to the organisation path" do
    get "/government/organisations/organisation-1/groups/group-1"

    expect(response).to redirect_to("/government/organisations/organisation-1")
  end

  it "redirects organisation series index path to the publications path" do
    get "/government/organisations/organisation-1/series"

    expect(response).to redirect_to("/government/publications")
  end

  it "redirects organisation localised series index path to the publications path" do
    get "/government/organisations/organisation-1/series.cy"

    expect(response).to redirect_to("/government/publications")
  end

  it "redirects organisation series path to the corresponding collections path" do
    get "/government/organisations/organisation-1/series/series-1"

    expect(response).to redirect_to("/government/collections/series-1")
  end

  it "redirects organisation localised series path to the correspondong collections path" do
    get "/government/organisations/organisation-1/series/series-1.cy"

    expect(response).to redirect_to("/government/collections/series-1")
  end
end
