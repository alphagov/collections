require "test_helper"

describe Person do
  setup do
    @api_data = {
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
    @content_item = ContentItem.new(@api_data)
    @person = Person.new(@content_item)
  end

  describe "current_roles_title" do
    it "combines the titles into a sentence" do
      assert_equal "Prime Minister and First Lord of the Treasury", @person.current_roles_title
    end
  end

  describe "currently_in_a_role?" do
    it "returns true if the person has a current role appointment" do
      assert @person.currently_in_a_role?
    end

    it "returns false if the person doesn't have a current role appointment" do
      @api_data["links"]["role_appointments"][0]["details"]["current"] = false
      @api_data["links"]["role_appointments"][1]["details"]["current"] = false
      assert_not @person.currently_in_a_role?
    end
  end

  describe "ordered previous appointments" do
    it "should have previous appointment text" do
      assert_equal "Secretary of State for Foreign and Commonwealth Affairs", @person.previous_roles_items.first[:link][:text]
    end

    it "should have previous appointment duration text" do
      assert_equal "2016 to 2018", @person.previous_roles_items.first[:metadata][:appointment_duration]
    end
  end

  describe "announcements" do
    setup do
      @results = [
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

      Services.search_api.stubs(:search).returns(
        "results" => @results,
        "start" => 0,
        "total" => 1,
      )
    end

    it "should have announcements" do
      assert_equal "Government announces further support for those affected by flooding", @person.announcements.items.first[:link][:text]
    end

    it "should have link to news and communications finder" do
      assert_equal "/search/news-and-communications?people=boris-johnson", @person.announcements.links[:link_to_news_and_communications]
    end

    it "should have link to email signup" do
      assert_equal "/email-signup?link=/government/people/boris-johnson", @person.announcements.links[:email_signup]
    end

    it "should have link to subscription atom feed" do
      assert_equal "/search/news-and-communications.atom?people=boris-johnson", @person.announcements.links[:subscribe_to_feed]
    end
  end
end
