require "test_helper"

describe Person do
  setup do
    @api_data = {
      "base_path" => "/government/people/boris-johnson",
      "links" => {
        "ordered_current_appointments" => [
          {
            "links" => {
              "role" => [{
                "title" => "Prime Minister",
              }],
            },
          },
          {
            "links" => {
              "role" => [{
                "title" => "First Lord of the Treasury",
              }],
            },
          },
        ],
        "ordered_previous_appointments" => [
          {
            "details" => {
              "started_on" => "2016-07-13T00:00:00+01:00",
              "ended_on" => "2018-07-09T00:00:00+01:00",
            },
            "links" => {
              "role" => [
                {
                  "title" => "Secretary of State for Foreign and Commonwealth Affairs",
                },
              ],
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

  describe "ordered previous appointments" do
    it "should have previous appointment text" do
      assert_equal "Secretary of State for Foreign and Commonwealth Affairs", @person.previous_roles_items.first[:link][:text]
    end

    it "should have previous appointment duration text" do
      assert_equal "2016 to 2018", @person.previous_roles_items.first[:metadata][:appointment_duration]
    end
  end

  describe "announcements" do
    it "should have annoucements" do
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

      Services.rummager.stubs(:search).returns("results" => results,
        "start" => 0,
        "total" => 1)

      assert_equal "Government announces further support for those affected by flooding", @person.announcement_items.first[:link][:text]
    end
  end
end
