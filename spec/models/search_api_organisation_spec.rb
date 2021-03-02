RSpec.describe SearchApiOrganisation do
  it "returns the state of an organisation" do
    organisation = described_class.new(
      organisation_state: "live",
    )
    expect(organisation.live?).to be(true)
  end

  it "returns false if the state of an organisation is not live" do
    organisation = described_class.new(
      organisation_state: "closed",
    )
    expect(organisation.live?).to be(false)
  end

  describe "#has_logo?" do
    it "returns true if logo attributes are present" do
      organisation = described_class.new(
        logo_formatted_title: "some\ntitle",
        brand: "ministry-of-blah",
        crest: "single-identity",
      )
      expect(organisation.has_logo?).to be(true)
    end

    it "returns false if the crest is missing" do
      organisation = described_class.new(
        logo_formatted_title: "some\ntitle",
        brand: "ministry-of-blah",
        crest: "",
      )
      expect(organisation.has_logo?).to be(false)
    end

    it "returns false if the it is a custom logo" do
      organisation = described_class.new(
        crest: "custom",
        logo_url: "/logo.png",
      )
      expect(organisation.has_logo?).to be(false)
    end
  end

  describe "#custom_logo?" do
    it 'returns true if the crest is "custom"' do
      organisation = described_class.new(
        crest: "custom",
        logo_url: "/logo.png",
      )
      expect(organisation.custom_logo?).to be(true)
    end

    it 'returns false if the crest is not "custom"' do
      organisation = described_class.new(
        crest: "somethingelse",
        logo_url: "/logo.png",
      )
      expect(organisation.custom_logo?).to be(false)
    end

    it "returns false if the logo url is missing" do
      organisation = described_class.new(
        crest: "somethingelse",
      )
      expect(organisation.custom_logo?).to be(false)
    end
  end
end
