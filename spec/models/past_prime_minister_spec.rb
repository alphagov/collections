RSpec.describe PastPrimeMinister do
  let(:api_data) do
    {
      "details" => {
        "born" => "1900",
        "died" => "2000",
        "interesting_facts" => "a fact",
        "major_acts" => "an act",
        "political_party" => "A party",
        "dates_in_office" => [
          {
            "end_year" => 2005,
            "start_year" => 2000,
          },
          {
            "end_year" => 1992,
            "start_year" => 1987,
          },
        ],
      },
    }
  end

  let(:content_item) { ContentItem.new(api_data) }
  let(:appointment) { described_class.new(content_item) }

  describe "dates_in_office" do
    it "interpolates previous dates in office" do
      output = "2000 to 2005, 1987 to 1992"
      expect(appointment.dates_in_office).to eq(output)
    end
  end

  describe "appointment_info_array" do
    it "creates an array of all the info" do
      expected_info = [
        { title: "Born", text: "1900" },
        { title: "Died", text: "2000" },
        { title: "Dates in office", text: "2000 to 2005, 1987 to 1992" },
        { title: "Political party", text: "A party" },
        { title: "Major acts", text: "an act" },
        { title: "Interesting facts", text: "a fact" },
      ]
      expect(appointment.appointment_info_array).to eq(expected_info)
    end
  end
end
