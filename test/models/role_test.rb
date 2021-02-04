require "test_helper"

describe Role do
  setup do
    @api_data = {
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
    @content_item = ContentItem.new(@api_data)
    @role = Role.new(@content_item)
  end

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
      assert_equal expected, @role.organisations
    end
  end

  describe "current_holder" do
    context "without a current holder" do
      setup do
        @api_data["links"]["role_appointments"][1]["details"]["current"] = false
      end

      it "should return nil" do
        assert_nil @role.current_holder
      end
    end

    context "with a current holder" do
      setup do
        @expected = {
          "title" => "The Rt Hon Boris Johnson",
          "base_path" => "/government/people/boris-johnson",
          "details" => {
            "body" => "<p>Boris Johnson became Prime Minister on 24 July 2019. He was previously Foreign Secretary from 13 July 2016 to 9 July 2018. He was elected Conservative MP for Uxbridge and South Ruislip in May 2015. Previously he was the MP for Henley from June 2001 to June 2008.</p> ",
          },
        }
      end

      it "should have title and base_path" do
        assert_equal @expected, @role.current_holder
      end

      it "should have body with biography" do
        assert_equal @expected["details"]["body"], @role.current_holder_biography
      end

      it "should have link to person" do
        assert_equal @expected["base_path"], @role.link_to_person
      end
    end
  end

  describe "announcements" do
    setup do
      @results = [
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

      Services.search_api.stubs(:search).returns(
        "results" => @results,
        "start" => 0,
        "total" => 1,
      )
    end

    it "should have announcements" do
      assert_equal "PM statement at NATO meeting: 4 December 2019", @role.announcements.items.first[:link][:text]
    end

    it "should have link to email signup" do
      assert_equal "/email-signup?link=/government/ministers/prime-minister", @role.announcements.links[:email_signup]
    end

    it "should have link to subscription atom feed" do
      assert_equal "/search/news-and-communications.atom?roles=prime-minister", @role.announcements.links[:subscribe_to_feed]
    end

    it "should have link to news and communications finder" do
      assert_equal "/search/news-and-communications?roles=prime-minister", @role.announcements.links[:link_to_news_and_communications]
    end
  end

  describe "supports_historical_accounts" do
    context "without a historical account page" do
      it "does not support historical accounts by default" do
        assert_not @role.supports_historical_accounts?
      end
    end
    context "with a historical account page" do
      setup do
        @api_data["details"]["supports_historical_accounts"] = true
      end
      it "supports historical accounts" do
        assert @role.supports_historical_accounts?
      end
      it "points to the correct historical account page" do
        assert @role.past_holders_url == "/government/history/past-prime-ministers"
      end
    end

    context "when applied to a chancellor" do
      setup do
        @api_data["title"] = "Chancellor of the Exchequer"
        @api_data["base_path"] = "/government/ministers/chancellor-of-the-exchequer"
      end

      it "points to the correct historical account page" do
        assert @role.past_holders_url == "/government/history/past-chancellors"
      end
    end
    context "when applied to a foreign secretary" do
      setup do
        @api_data["title"] = "Secretary of State for Foreign, Commonwealth and Development Affairs"
        @api_data["base_path"] = "/government/ministers/secretary-of-state-for-foreign-commonwealth-and-development-affairs"
      end

      it "points to the correct historical account page" do
        assert @role.past_holders_url == "/government/history/past-foreign-secretaries"
      end
    end
  end
end
