require 'test_helper'
class EmailHelperTest < ActionView::TestCase
  test "should return true if we are browsing a world location" do
    world_location_base_path = "/world/blefuscu"

    assert render_whitehall_email_links?(world_location_base_path)
  end

  test "should return false if we are browsing any other taxon" do
    base_path = "/education/student-finance"

    refute render_whitehall_email_links?(base_path)
  end

  test "should return a valid whitehall .atom url in the form /government/{url}.atom" do
    define_singleton_method(:request) do
      return OpenStruct.new(fullpath: "/world/blefuscu")
    end

    expected_atom_url = Plek.new.website_root + "/world/blefuscu.atom"

    assert_equal expected_atom_url, whitehall_atom_url
  end

  test "should return a valid whitehall email signup link" do
    define_singleton_method(:request) do
      return OpenStruct.new(fullpath: "/world/blefuscu")
    end

    atom_url = Plek.new.website_root + "/world/blefuscu.atom"
    expected_url = Plek.new.website_root +
      URI.encode("/government/email-signup/new?email_signup[feed]=#{atom_url}")

    assert_equal expected_url, whitehall_email_url
  end
end
