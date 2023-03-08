require "integration_spec_helper"

RSpec.feature "Past Prime Minister pages" do
  context "Individual past prime minister pages" do
    let(:base_path) { "/government/history/past-prime-ministers/test-pm" }
    let(:content_item) do
      {
        base_path:,
        title: "The Rt Hon Test Pm",
        description: "Not a real person",
        details: {
          political_party: "Fake Party",
          dates_in_office: [
            {
              end_year: 2005,
              start_year: 2000,
            },
          ],
          body: "<p class=body_text>Some body text</p>",
          born: "1 January 1900, Laceby, Lincolnshire",
          died: "31st December 2005, Hundalee, Jedburgh, Scotland",
          major_acts: "Played King Lear in a local production in Carmarthen, Wales",
          interesting_facts: "Opened a village hall in Tullyhogue, Northern Island, in 1964",
        },
        links: {
          person: [
            details: {
              image: {
                url: "/test/pm",
                alt_text: "A picture of test PM",
              },
            },
          ],
          ordered_related_items: [
            { title: "Another PM",
              base_path: "/another-pm" },
          ],
        },
      }
    end

    context "when a past prime minister has all fields" do
      before do
        stub_content_store_has_item(base_path, content_item)
        visit base_path
      end

      it "sets the page title" do
        expect(page).to have_title("#{content_item[:title]} - GOV.UK")
      end

      it "renders the relevant text field from the top level content item fields" do
        top_level_fields = %i[title description]
        top_level_fields.each { |field| expect(page).to have_text(content_item[field]) }
      end

      it "renders the relevant text fields from the content item's details" do
        expected_details_fields = %i[born died major_acts interesting_facts political_party]
        expected_details_fields.each do |field|
          expect(page).to have_css("h2", text: field.to_s.gsub("_", " ").capitalize)
          expect(page).to have_text(content_item.dig(:details, field))
        end
      end

      it "renders the biography on the page" do
        expect(page).to have_text("Some body text")
        expect(page).to have_css(".body_text")
      end

      it "renders the dates served along with the political party on the page" do
        expect(page).to have_text("Fake Party 2000 to 2005")
      end

      it "renders the image on the page" do
        image = find("img")
        expect(image["src"]).to eq("/test/pm")
        expect(image["alt"]).to eq("A picture of test PM")
      end

      it "renders the related pms on the page" do
        within ".gem-c-related-navigation" do
          expect(page).to have_link("Another PM", href: "/another-pm")
        end
      end
    end

    context "when a past prime minister does not have all optional fields" do
      let(:base_path) { "/government/history/past-prime-ministers/test-pm" }
      let(:fields_to_exclude) { %i[born died major_acts interesting_facts] }
      let(:shortened_content_item) do
        content_item.tap do |content|
          content[:details] = content[:details].map { |k, v| fields_to_exclude.include?(k) ? [k, ""] : [k, v] }.to_h
        end
      end

      before do
        stub_content_store_has_item(base_path, shortened_content_item)
        visit base_path
      end

      it "renders the relevant text field from the top level content item fields" do
        top_level_fields = %i[title description]
        top_level_fields.each { |field| expect(page).to have_text(content_item[field]) }
      end

      it "does not render the excluded fields" do
        fields_to_exclude.each { |field| expect(page).not_to have_css("h2", text: field.to_s.gsub("_", " ").capitalize) }
      end
    end
  end

  context "past prime ministers index page" do
    include PrimeMinistersHelpers

    let(:base_path) { "/government/history/past-prime-ministers" }
    let(:data_for_nineteenth_century_pm) { api_data_for_person_with_historical_account("The Rt Honourable Mrs A", "mrs-a", "/image", [1801], "Labour") }
    let(:data_for_twentieth_century_pm) { api_data_for_person_with_historical_account("The Rt Honourable Mr B", "mr-b", "/image", [1972], "Labour") }
    let(:data_for_twenty_first_century_pm) { api_data_for_person_without_historical_account("The Rt Honourable Mrs C", "/image", [2022]) }
    let(:content_item) { past_pms_content_item([data_for_nineteenth_century_pm, data_for_twentieth_century_pm], [data_for_twenty_first_century_pm]) }

    before do
      stub_content_store_has_item(base_path, content_item)
      visit base_path
    end

    it "sets the page title" do
      expect(page).to have_title("Past Prime Ministers")
    end

    it "renders the title of the page" do
      expect(page).to have_text("Past Prime Ministers")
    end

    it "renders the century headings" do
      expect(page).to have_text "18th & 19th centuries"
      expect(page).to have_text "20th century"
      expect(page).to have_text "21st century"
    end

    it "renders the correct people in each century" do
      within('div#historical-people-18th-\&-19th-centuries') do
        expect(page).to have_text data_for_nineteenth_century_pm["title"]
      end

      within("div#historical-people-20th-century") do
        expect(page).to have_text data_for_twentieth_century_pm["title"]
      end

      within("div#historical-people-21st-century") do
        expect(page).to have_text data_for_twenty_first_century_pm["title"]
      end
    end
  end
end
