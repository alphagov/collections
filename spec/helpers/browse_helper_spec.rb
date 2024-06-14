RSpec.describe BrowseHelper do
  describe "#with_tracking_data" do
    it "returns formatted popular links" do
      popular_content_from_search = [
        {
          'link': "/foo/policy_paper",
          'title': "Policy on World Locations",
        },
        {
          'link': "/foo/news_story",
          'title': "PM attends summit on world location news pages",
        },
        {
          'link': "/foo/anything",
          'title': "Anything",
        },
      ]

      expected_links = [
        {
          text: "Policy on World Locations",
          href: "/foo/policy_paper",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 1,
              index_total: 3,
              text: "Policy on World Locations",
              section: "Popular tasks",
            },
          },
        },
        {
          text: "PM attends summit on world location news pages",
          href: "/foo/news_story",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 2,
              index_total: 3,
              text: "PM attends summit on world location news pages",
              section: "Popular tasks",
            },
          },
        },
        {
          text: "Anything",
          href: "/foo/anything",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 3,
              index_total: 3,
              text: "Anything",
              section: "Popular tasks",
            },
          },
        },
      ]
      expect(helper.with_tracking_data(popular_content_from_search)).to eq(expected_links)
    end
  end
end
