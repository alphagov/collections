RSpec.describe EmailHelper do
  it "should return true if we are browsing a taxon that is live" do
    presented_taxon = double
    allow(presented_taxon).to receive(:live_taxon?) { true }
    expect(helper.taxon_is_live?(presented_taxon)).to be true
  end

  it "should return false if we are browsing a taxon that is not live" do
    presented_taxon = double
    allow(presented_taxon).to receive(:live_taxon?) { false }
    expect(helper.taxon_is_live?(presented_taxon)).to be false
  end
  it "should return a valid atom url" do
    controller.request = ActionDispatch::TestRequest.create("PATH_INFO" => "/world/blefuscu")

    expected_atom_url = "#{Plek.new.website_root}/world/blefuscu.atom"
    expect(helper.whitehall_atom_url).to eq(expected_atom_url)
  end

  it "should return a valid email alert frontend email signup link" do
    taxon = double
    allow(taxon).to receive(:base_path) { "/world/blefuscu" }
    expected_url = "#{Plek.new.website_root}/email-signup?link=/world/blefuscu"
    expect(helper.email_alert_frontend_signup_url(taxon)).to eq(expected_url)
  end
end
