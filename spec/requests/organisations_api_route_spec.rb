RSpec.describe "Organisations api routes" do
  it "should respond with '404 for a bad route'" do
    get "/api/organisations/bad/route", as: :json

    expect(response).to have_http_status(:not_found)
    expect(response.body).to eq("404 error")
  end
end
