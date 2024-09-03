RSpec.describe BrowseHelper do
  before do
    class << helper
      def popular_tasks_variant_a_page?
        false
      end

      def popular_tasks_variant_b_page?
        false
      end
    end
  end

  describe "#display_popular_links_for_slug?" do
    it "returns true for existing slug" do
      expect(helper.display_popular_links_for_slug?("business")).to be(true)
    end

    it "returns false for nonexisting slug" do
      expect(helper.display_popular_links_for_slug?("random12345")).to be(false)
    end
  end

  describe "#popular_links_for_slug" do
    it "returns popular links data" do
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
              section: "popular tasks",
            },
          },
        },
        {
          text: "Self Assessment tax returns",
          href: "/self-assessment-tax-returns",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 2,
              index_total: 3,
              text: "Self Assessment tax returns",
              section: "popular tasks",
            },
          },
        },
        {
          text: "Pay employers' PAYE",
          href: "/pay-paye-tax",
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_track_links_only: "",
            ga4_link: {
              event_name: "navigation",
              type: "action",
              index_link: 3,
              index_total: 3,
              text: "Pay employers' PAYE",
              section: "popular tasks",
            },
          },
        },
      ]
      expect(helper.popular_links_for_slug("business")).to eq(expected_links)
    end
  end
end
