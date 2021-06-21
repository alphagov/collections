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

  describe "#timeline_for_nation" do
    it "only returns the entries for requested country" do
      timeline_list = [
        {
          "heading" => "England applicability",
          "national_applicability" => %w[england],
          "paragraph" => "Timeline entry only applies to England.",
        },
        {
          "heading" => "Wales applicability",
          "national_applicability" => %w[wales],
          "paragraph" => "Timeline entry only applies to Wales.",
        },
      ]

      expect(helper.timeline_for_nation(timeline_list, "wales").size).to eq(1)
      expect(helper.timeline_for_nation(timeline_list, "wales").first).to match(hash_including("heading" => "Wales applicability"))
    end

    it "returns entries shared by multiple countries" do
      timeline_list = [
        {
          "heading" => "England and Wales applicability",
          "national_applicability" => %w[england wales],
          "paragraph" => "Timeline entry applies to England and Wales.",
        },
      ]

      expect(helper.timeline_for_nation(timeline_list, "wales").size).to eq(1)
      expect(helper.timeline_for_nation(timeline_list, "wales").first).to match(hash_including("heading" => "England and Wales applicability"))
    end
  end

  describe "#uk_wide?" do
    it "returns true if the national_applicability applies to all uk nations" do
      national_applicability = %w[england northern_ireland scotland wales]
      expect(helper.uk_wide?(national_applicability)).to be true
    end

    it "returns true if the national_applicability applies to all uk nations regardless of order" do
      national_applicability = %w[scotland wales england northern_ireland]
      expect(helper.uk_wide?(national_applicability)).to be true
    end

    it "returns false if national_applicability does not apply to all countries" do
      national_applicability = %w[england northern_ireland]
      expect(helper.uk_wide?(national_applicability)).to be false
    end
  end
end
