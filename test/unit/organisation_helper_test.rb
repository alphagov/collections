require "test_helper"

describe OrganisationHelper do
  describe "#organisation_type_name" do
    it "returns a human-readable name given an organisation_type" do
      assert_equal "Executive non-departmental public body", organisation_type_name("executive_ndpb")
    end

    it "returns 'other' for an unrecognised organisation_type" do
      assert_equal "Other", organisation_type_name("something_else")
    end
  end
end
