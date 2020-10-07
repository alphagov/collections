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

  it "returns the guidance" do
    guidance = restriction.guidance
    assert_equal "These are not the restrictions you are looking for", guidance["label"]
    assert_equal "guidance/tatooine-local-restrictions", guidance["link"]
  end

  it "returns the extra restrictions" do
    assert_nil restriction.extra_restrictions
  end

  it "returns nil values if the gss code doesn't exist" do
    restriction = described_class.new("fake code")
    assert_nil restriction.area_name
    assert_nil restriction.guidance
  end

  describe "#start_date" do
    it "returns the start date" do
      assert_equal "01 October 2020".to_date, restriction.start_date
    end

    it "allows the start date to be nil" do
      restriction = described_class.new("E08000002")
      assert_nil restriction.start_date
    end
  end

  describe "#end_date" do
    it "returns the end date" do
      assert_equal "02 October 2020".to_date, restriction.end_date
    end

    it "allows the end date to be nil" do
      restriction = described_class.new("E08000002")
      assert_nil restriction.end_date
    end
  end
end
