require "test_helper"

describe EmailHelper do
  it "should return true if we are browsing a taxon that is live" do
    presented_taxon = stub(
      live_taxon?: true,
    )

    assert taxon_is_live?(presented_taxon)
  end

  it "should return false if we are browsing a taxon that is not live" do
    presented_taxon = stub(
      live_taxon?: false,
    )

    assert_not taxon_is_live?(presented_taxon)
  end

  it "should return a valid atom url" do
    stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => "/world/blefuscu"))

    expected_atom_url = Plek.new.website_root + "/world/blefuscu.atom"

    assert_equal expected_atom_url, whitehall_atom_url
  end

  it "should return a valid email alert frontend email signup link" do
    stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => "/world/blefuscu"))
    taxon = stub(base_path: "/world/blefuscu")

    expected_url = "#{Plek.new.website_root}/email-signup?link=/world/blefuscu"

    assert_equal expected_url, email_alert_frontend_signup_url(taxon)
  end
end
