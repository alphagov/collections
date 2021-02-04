require "test_helper"

describe SearchApiOrganisation do
  it "returns the state of an organisation" do
    organisation = SearchApiOrganisation.new(
      organisation_state: "live",
    )
    assert(organisation.live?)
  end

  it "returns false if the state of an organisation is not live" do
    organisation = SearchApiOrganisation.new(
      organisation_state: "closed",
    )
    assert_not(organisation.live?)
  end

  describe "#has_logo?" do
    it "returns true if logo attributes are present" do
      organisation = SearchApiOrganisation.new(
        logo_formatted_title: "some\ntitle",
        brand: "ministry-of-blah",
        crest: "single-identity",
      )
      assert(organisation.has_logo?)
    end

    it "returns false if the crest is missing" do
      organisation = SearchApiOrganisation.new(
        logo_formatted_title: "some\ntitle",
        brand: "ministry-of-blah",
        crest: "",
      )
      assert_not(organisation.has_logo?)
    end

    it "returns false if the it is a custom logo" do
      organisation = SearchApiOrganisation.new(
        crest: "custom",
        logo_url: "/logo.png",
      )
      assert_not(organisation.has_logo?)
    end
  end

  describe "#custom_logo?" do
    it 'returns true if the crest is "custom"' do
      organisation = SearchApiOrganisation.new(
        crest: "custom",
        logo_url: "/logo.png",
      )
      assert(organisation.custom_logo?)
    end

    it 'returns false if the crest is not "custom"' do
      organisation = SearchApiOrganisation.new(
        crest: "somethingelse",
        logo_url: "/logo.png",
      )
      assert_not(organisation.custom_logo?)
    end

    it "returns false if the logo url is missing" do
      organisation = SearchApiOrganisation.new(
        crest: "somethingelse",
      )
      assert_not(organisation.custom_logo?)
    end
  end
end
