require "test_helper"

describe EmailHelper do
  it "should return true if we are browsing a taxon that is live" do
    presented_taxon = stub(
      live_taxon?: true
    )

    assert taxon_is_live?(presented_taxon)
  end

  it "should return false if we are browsing a taxon that is not live" do
    presented_taxon = stub(
      live_taxon?: false
    )

    refute taxon_is_live?(presented_taxon)
  end

  it "should return a valid whitehall .atom url in the form /government/{url}.atom" do
    self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => '/world/blefuscu'))

    expected_atom_url = Plek.new.website_root + "/world/blefuscu.atom"

    assert_equal expected_atom_url, whitehall_atom_url
  end

  it "should return a valid whitehall email signup link" do
    self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => '/world/blefuscu'))

    atom_url = Plek.new.website_root + "/world/blefuscu.atom"
    expected_url = "#{Plek.new.website_root}/government/email-signup/new?email_signup[feed]=#{atom_url}"

    assert_equal expected_url, whitehall_email_url
  end
end
