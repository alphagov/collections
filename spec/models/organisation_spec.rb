RSpec.describe Organisation do
  def organisation_with_slug(slug, brand: nil)
    described_class.new(
      ContentItem.new(
        "base_path" => "/government/organisations/#{slug}",
        "details" => { "brand" => brand },
      ),
    )
  end

  describe "#is_no_10?" do
    it "is true for the Number 10 slug" do
      expect(organisation_with_slug("prime-ministers-office-no-10")).to be_is_no_10
    end

    it "is false for other organisations" do
      expect(organisation_with_slug("attorney-generals-office")).not_to be_is_no_10
    end
  end

  describe "#brand" do
    it "is the old Number 10 slug for Number 10, as govuk-frontend and Whitehall still use it as the brand name" do
      expect(organisation_with_slug("prime-ministers-office-no-10").brand).to eq("prime-ministers-office-10-downing-street")
    end

    it "is the brand from the content item for other organisations" do
      expect(organisation_with_slug("attorney-generals-office", brand: "attorney-generals-office").brand).to eq("attorney-generals-office")
    end
  end
end
