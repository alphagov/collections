require "integration_test_helper"

class OrganisationApiRouteTest < ActionDispatch::IntegrationTest
  it "should respond with '404 for a bad route'" do
    get "/api/organisations/bad/route", as: :json

    assert_equal 404, response.status
    assert_equal "404 error", response.body
  end
end
