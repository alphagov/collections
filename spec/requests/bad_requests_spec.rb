RSpec.describe "Bad requests on any route" do
  it "should respond with '400 for an invalid base path'" do
    pending
    get "/government/organisations/fair-work-agency/%0D%0AWas-Header:wasDCV4eqabout"

    expect(response).to have_http_status(:bad_request)
  end
end
