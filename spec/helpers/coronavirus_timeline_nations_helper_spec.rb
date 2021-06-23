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

  describe "#display_country" do
    it "should return england by default" do
      expect(helper.display_country).to eq("england")
    end

    it "should return england if selected country is not in the uk" do
      expect(helper.display_country("foo")).to eq("england")
    end

    it "should return selected county if country is in the uk" do
      expect(helper.display_country("wales")).to eq("wales")
    end
  end

  describe "#timeline_nations_items" do
    let(:expected) do
      [
        {
          checked: true,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "England",
            },
          text: "England",
          value: "england",
        },
        {
          checked: false,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Northern Ireland",
            },
          text: "Northern Ireland",
          value: "northern_ireland",
        },
        {
          checked: false,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Scotland",
            },
          text: "Scotland",
          value: "scotland",
        },
        {
          checked: false,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Wales",
            },
          text: "Wales",
          value: "wales",
        },
      ]
    end

    it "sets england to selected by default" do
      expect(helper.timeline_nations_items).to eq(expected)
    end

    it "sets england to selected if selected country is not in the uk" do
      expect(helper.timeline_nations_items("foo")).to eq(expected)
    end

    it "sets selected county to selected if selected country is in the uk" do
      expected = [
        {
          checked: false,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "England",
            },
          text: "England",
          value: "england",
        },
        {
          checked: false,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Northern Ireland",
            },
          text: "Northern Ireland",
          value: "northern_ireland",
        },
        {
          checked: false,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Scotland",
            },
          text: "Scotland",
          value: "scotland",
        },
        {
          checked: true,
          data_attributes:
            {
              track_action: "TimelineNation",
              track_category: "pageElementInteraction",
              track_label: "Wales",
            },
          text: "Wales",
          value: "wales",
        },
      ]
      expect(helper.timeline_nations_items("wales")).to eq(expected)
    end
  end
end
