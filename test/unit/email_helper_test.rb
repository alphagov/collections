require 'test_helper'
class EmailHelperTest < ActionView::TestCase
  test "should return true if we are browsing a world location" do
    presented_taxon = stub(
      world_related?: true,
      renders_as_accordion?: true,
      live_taxon?: true
    )

    assert render_whitehall_email_links?(presented_taxon)
  end

  test "should return false if we are browsing a world location leaf page" do
    presented_taxon = stub(
      world_related?: true,
      renders_as_accordion?: false,
      live_taxon?: true
    )

    refute render_whitehall_email_links?(presented_taxon)
  end

  test "should return false if we are browsing any other taxon" do
    presented_taxon = stub(
      world_related?: false,
      renders_as_accordion?: true,
      live_taxon?: true
    )

    refute render_whitehall_email_links?(presented_taxon)
  end


  test "should return true if we are browsing a taxon that is live" do
    presented_taxon = stub(
      live_taxon?: true
    )

    assert taxon_is_live?(presented_taxon)
  end

  test "should return false if we are browsing a taxon that is not live" do
    presented_taxon = stub(
      live_taxon?: false
    )

    refute taxon_is_live?(presented_taxon)
  end

  test "should return a valid whitehall .atom url in the form /government/{url}.atom" do
    self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => '/world/blefuscu'))

    expected_atom_url = Plek.new.website_root + "/world/blefuscu.atom"

    assert_equal expected_atom_url, whitehall_atom_url
  end

  test "should return a valid whitehall email signup link" do
    self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => '/world/blefuscu'))

    atom_url = Plek.new.website_root + "/world/blefuscu.atom"
    expected_url = Plek.new.website_root +
      URI.encode("/government/email-signup/new?email_signup[feed]=#{atom_url}")

    assert_equal expected_url, whitehall_email_url
  end
end
