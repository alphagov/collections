require "test_helper"

describe Subcategory, ".find" do
  it "finds the curated content for the given slug in the collections api" do
    slug = "oil-and-gas/wells"
    collections_api_has_curated_lists_for("/#{slug}")

    subcategory = Subcategory.find(slug)

    assert_instance_of Subcategory, subcategory
  end

  it "returns nil if there is no content for the given slug in the collections api" do
    slug = "nothing-here"
    collections_api_has_no_curated_lists_for("/#{slug}")

    subcategory = Subcategory.find(slug)

    assert_equal nil, subcategory
  end
end

describe Subcategory, "#content" do
  it "returns the content for the subcategory" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_curated_lists_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subcategory = Subcategory.find(slug)

    assert_equal stubbed_response_body['details']['groups'][0]['title'], subcategory.content.first.title
  end
end

describe Subcategory, "#description" do
  it "returns the description for the subcategory" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_curated_lists_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subcategory = Subcategory.find(slug)

    assert_equal stubbed_response_body['description'], subcategory.description
  end
end

describe Subcategory, "#title" do
  it "returns the title for the subcategory" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_curated_lists_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subcategory = Subcategory.find(slug)

    assert_equal stubbed_response_body['title'], subcategory.title
  end
end

describe Subcategory, "#parent_sector_title" do
  it "returns the parent sector for the subcategory" do
    slug = "oil-and-gas/wells"
    stubbed_response = collections_api_has_curated_lists_for("/#{slug}")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)

    subcategory = Subcategory.find(slug)

    assert_equal stubbed_response_body['parent']['title'], subcategory.parent_sector_title
  end
end
