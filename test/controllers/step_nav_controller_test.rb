require "test_helper"

describe StepNavController do
  it "returns a 404 when the page doesn't exist" do
    slug = SecureRandom.hex
    stub_content_store_does_not_have_item("/#{slug}")

    get :show, params: { slug: slug }

    assert_response 404
  end
end
