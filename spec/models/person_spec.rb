RSpec.describe Person do
  include SearchApiHelpers

  let(:api_data) do
    {
      "base_path" => "/government/people/boris-johnson",
      "links" => {
        "role_appointments" => [
          {
            "links" => {
              "role" => [{
                "title" => "Prime Minister",
              }],
            },
            "details" => {
              "current" => true,
              "person_appointment_order" => 1,
            },
          },
          {
            "links" => {
              "role" => [{
                "title" => "First Lord of the Treasury",
              }],
            },
            "details" => {
              "current" => true,
              "person_appointment_order" => 2,
            },
          },
          {
            "links" => {
              "role" => [
                {
                  "title" => "Secretary of State for Foreign and Commonwealth Affairs",
                },
              ],
            },
            "details" => {
              "current" => false,
              "person_appointment_order" => 3,
              "started_on" => "2016-07-13T00:00:00+01:00",
              "ended_on" => "2018-07-09T00:00:00+01:00",
            },
          },
        ],
      },
    }
  end
  let(:content_item) { ContentItem.new(api_data) }
  let(:person) { described_class.new(content_item) }

  describe "current_roles_title" do
    it "combines the titles into a sentence" do
      expect(person.current_roles_title).to eq("Prime Minister and First Lord of the Treasury")
    end

    it "combines the titles into a sentence for translated content" do
      api_data["locale"] = "ar"
      api_data["links"]["role_appointments"].first["links"]["role"].first["title"] = "المفوض التجاري لصاحب الجلالة لمنطقة الشرق الأوسط"
      api_data["links"]["role_appointments"].second["links"]["role"].first["title"] = "القنصل العام لصاحب الجلالة في دبي"
      # Arabic letter 'و' == 'and'
      expect(person.current_roles_title).to eq("المفوض التجاري لصاحب الجلالة لمنطقة الشرق الأوسط و القنصل العام لصاحب الجلالة في دبي")
    end
  end

  describe "currently_in_a_role?" do
    it "returns true if the person has a current role appointment" do
      expect(person.currently_in_a_role?).to be(true)
    end

    it "returns false if the person doesn't have a current role appointment" do
      api_data["links"]["role_appointments"][0]["details"]["current"] = false
      api_data["links"]["role_appointments"][1]["details"]["current"] = false
      expect(person.currently_in_a_role?).to be(false)
    end
  end

  describe "ordered previous appointments" do
    it "should have previous appointment text" do
      text = person.previous_roles_items.first[:link][:text]

      expect(text).to eq("Secretary of State for Foreign and Commonwealth Affairs")
    end

    it "should have previous appointment duration text" do
      duration = person.previous_roles_items.first[:metadata][:appointment_duration]
      expect(duration).to eq("2016 to 2018")
    end
  end

  describe "announcements" do
    before do
      results = [
        { "title" => "Government announces further support for those affected by flooding",
          "link" => "/government/news/government-announces-further-support-for-those-affected-by-flooding",
          "content_store_document_type" => "press_release",
          "public_timestamp" => "2019-11-12T21:07:00.000+00:00",
          "index" => "government",
          "es_score" => nil,
          "_id" => "/government/news/government-announces-further-support-for-those-affected-by-flooding",
          "elasticsearch_type" => "edition",
          "document_type" => "edition" },
      ]

      body = {
        "results" => results,
        "start" => 0,
        "total" => 1,
      }

      stub_search(body:)
    end

    it "should have announcements" do
      text = person.announcements.items.first[:link][:text]
      expect(text).to eq("Government announces further support for those affected by flooding")
    end

    it "should have link to news and communications finder" do
      link = person.announcements.links[:link_to_news_and_communications]
      expect(link).to eq("/search/news-and-communications?people=boris-johnson")
    end

    it "should have link to email signup" do
      link = person.announcements.links[:email_signup]
      expect(link).to eq("/email-signup?link=/government/people/boris-johnson")
    end

    it "should have link to subscription atom feed" do
      link = person.announcements.links[:subscribe_to_feed]
      expect(link).to eq("/search/news-and-communications.atom?people=boris-johnson")
    end
  end
end
