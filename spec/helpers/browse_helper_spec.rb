RSpec.describe BrowseHelper do
  describe "#display_popular_links_for_slug?" do
    it "returns true if data exists" do
      expect(helper.display_popular_links_for_slug?("business")).to be(true)
    end

    it "returns false if no data exists" do
      expect(helper.display_popular_links_for_slug?("random12345")).to be(false)
    end
  end

  describe "#popular_links_for_slug" do
    it "adds GA tracking data to links" do
      expected_links = [
        {
          text: "HMRC online services: sign in or set up an account",
          href: "/log-in-register-hmrc-online-services",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 1,
              index_total: 3,
              text: "HMRC online services: sign in or set up an account",
              section: "Popular tasks",
            },
          },
        },
        {
          text: "Get information about a company",
          href: "/get-information-about-a-company",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 2,
              index_total: 3,
              text: "Get information about a company",
              section: "Popular tasks",
            },
          },
        },
        {
          text: "Find an energy certificate",
          href: "/find-energy-certificate",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 3,
              index_total: 3,
              text: "Find an energy certificate",
              section: "Popular tasks",
            },
          },
        },
      ]
      expect(helper.popular_links_for_slug("business")).to eq(expected_links)
    end
  end
end
