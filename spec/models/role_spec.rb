RSpec.describe Role do
  include SearchApiHelpers

  let(:api_data) do
    {
      "base_path" => "/government/ministers/prime-minister",
      "details" => {},
      "links" => {
        "ordered_parent_organisations" => [
          {
            "base_path" => "/government/organisations/cabinet-office",
            "title" => "Cabinet Office",
          },
          {
            "base_path" => "/government/organisations/prime-ministers-office-10-downing-street",
            "title" => "Prime Minister's Office, 10 Downing Street",
          },
        ],
        "role_appointments" => [
          {
            "details" => {
              "current" => false,
            },
            "links" => {
              "person" => [
                {
                  "title" => "The Rt Hon Theresa May",
                  "base_path" => "/government/people/theresa-may",
                },
              ],
            },
          },
          {
            "details" => {
              "current" => true,
            },
            "links" => {
              "person" => [
                {
                  "title" => "The Rt Hon Boris Johnson",
                  "base_path" => "/government/people/boris-johnson",
                  "details" => {
                    "body" => "<p>Boris Johnson became Prime Minister on 24 July 2019. He was previously Foreign Secretary from 13 July 2016 to 9 July 2018. He was elected Conservative MP for Uxbridge and South Ruislip in May 2015. Previously he was the MP for Henley from June 2001 to June 2008.</p> ",
                  },
                },
              ],
            },
          },
        ],
      },
    }
  end

  let(:content_item) { ContentItem.new(api_data) }
  let(:role) { described_class.new(content_item) }

  describe "organisations" do
    it "should have organisations title and base_path" do
      expected = [
        {
          "title" => "Cabinet Office",
          "base_path" => "/government/organisations/cabinet-office",
        },
        {
          "title" => "Prime Minister's Office, 10 Downing Street",
          "base_path" => "/government/organisations/prime-ministers-office-10-downing-street",
        },
      ]
      expect(role.organisations).to eq(expected)
    end
  end

  describe "current_holder" do
    let(:expected) do
      {
        "title" => "The Rt Hon Boris Johnson",
        "base_path" => "/government/people/boris-johnson",
        "details" => {
          "body" => "<p>Boris Johnson became Prime Minister on 24 July 2019. He was previously Foreign Secretary from 13 July 2016 to 9 July 2018. He was elected Conservative MP for Uxbridge and South Ruislip in May 2015. Previously he was the MP for Henley from June 2001 to June 2008.</p> ",
        },
      }
    end

    it "should have title and base_path" do
      expect(role.current_holder).to eq(expected)
    end

    it "should have body with biography" do
      expect(role.current_holder_biography).to eq(expected["details"]["body"])
    end

    it "should have link to person" do
      expect(role.link_to_person).to eq(expected["base_path"])
    end

    context "without a current holder" do
      before do
        api_data["links"]["role_appointments"][1]["details"]["current"] = false
      end

      it "should return nil" do
        role = described_class.new(content_item)
        expect(role.current_holder).to be_nil
      end
    end
  end

  describe "announcements" do
    before do
      results = [
        { "title" => "PM statement at NATO meeting: 4 December 2019",
          "link" => "/government/speeches/pm-statement-at-nato-meeting-4-december-2019",
          "content_store_document_type" => "speech",
          "public_timestamp" => "2019-11-12T21:07:00.000+00:00",
          "index" => "government",
          "es_score" => nil,
          "_id" => "/government/speeches/pm-statement-at-nato-meeting-4-december-2019",
          "elasticsearch_type" => "edition",
          "document_type" => "edition" },
      ]

      body = {
        "results" => results,
        "start" => 0,
        "total" => 1,
      }

      stub_search(body: body)
    end

    it "should have announcements" do
      expect(role.announcements.items.first[:link][:text]).to eq("PM statement at NATO meeting: 4 December 2019")
    end

    it "should have link to email signup" do
      expect(role.announcements.links[:email_signup]).to eq("/email-signup?link=/government/ministers/prime-minister")
    end

    it "should have link to subscription atom feed" do
      expect(role.announcements.links[:subscribe_to_feed]).to eq("/search/news-and-communications.atom?roles=prime-minister")
    end

    it "should have link to news and communications finder" do
      expect(role.announcements.links[:link_to_news_and_communications]).to eq("/search/news-and-communications?roles=prime-minister")
    end
  end

  describe "supports_historical_accounts" do
    context "without a historical account page" do
      it "does not support historical accounts by default" do
        expect(role.supports_historical_accounts?).to be_falsey
      end
    end

    context "with a historical account page" do
      before do
        api_data["details"]["supports_historical_accounts"] = true
      end

      it "supports historical accounts" do
        expect(role.supports_historical_accounts?).to be(true)
      end

      it "points to the correct historical account page" do
        expect(role.past_holders_url).to eq("/government/history/past-prime-ministers")
      end
    end

    context "when applied to a chancellor" do
      before do
        api_data["title"] = "Chancellor of the Exchequer"
        api_data["base_path"] = "/government/ministers/chancellor-of-the-exchequer"
      end

      it "points to the correct historical account page" do
        expect(role.past_holders_url).to eq("/government/history/past-chancellors")
      end
    end

    context "when applied to a foreign secretary" do
      before do
        api_data["title"] = "Secretary of State for Foreign, Commonwealth and Development Affairs"
        api_data["base_path"] = "/government/ministers/secretary-of-state-for-foreign-commonwealth-and-development-affairs"
      end

      it "points to the correct historical account page" do
        expect(role.past_holders_url).to eq("/government/history/past-foreign-secretaries")
      end
    end
  end
end
