RSpec.describe CoronavirusTimelineNationsHelper do
  describe "#show_timeline_nations?" do
    it "should return true if any timeline entry has national applicability" do
      timeline_list = [
        {
          "heading" => " No applicability",
          "paragraph" => "No applicability for timeline entry.",
        },
        {
          "heading" => "Has applicability",
          "national_applicability" => %w[wales],
          "paragraph" => "Timeline entry only applies to Wales",
        },
      ]

      expect(helper.show_timeline_nations?(timeline_list)).to be true
    end
  end
end
