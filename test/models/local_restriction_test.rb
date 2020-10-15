describe LocalRestriction do
  let(:restriction) { described_class.new("E08000001") }

  before do
    LocalRestriction.any_instance.stubs(:file_name).returns("test/fixtures/local-restrictions.yaml")
  end

  it "returns the area name" do
    assert_equal "Tatooine", restriction.area_name
  end

  it "returns the alert level" do
    assert_equal 4, restriction.alert_level
  end

  it "returns nil values if the gss code doesn't exist" do
    restriction = described_class.new("fake code")
    assert_nil restriction.area_name
  end
end
