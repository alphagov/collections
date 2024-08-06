RSpec.describe BrowseHelper do
  describe "#display_popular_links_for_slug?" do
    it "returns true for existing slug" do
      expect(helper.display_popular_links_for_slug?("business")).to be(true)
    end

    it "returns fails for nonexisting slug" do
      expect(helper.display_popular_links_for_slug?("random12345")).to be(false)
    end
  end

  describe "#each_popular_link_for_slug" do
    it "iterates over popular links" do
      yielded_links = []
      yielded_analytics_labels = []
      yielded_link_indexes = []
      yielded_link_counts = []
      helper.each_popular_link_for_slug("business") do |link, analytics_label, link_index, link_count|
        yielded_links << link
        yielded_analytics_labels << analytics_label
        yielded_link_indexes << link_index
        yielded_link_counts << link_count
      end
      expected_links = [
        {
          title: "HMRC online services: sign in or set up an account",
          url: "/log-in-register-hmrc-online-services",
          analytics_label_key: "hmrc_online_services",
        },
        {
          title: "Self Assessment tax returns",
          url: "/self-assessment-tax-returns",
          analytics_label_key: "self_assessment_tax_returns",
        },
        {
          title: "Pay employers' PAYE",
          url: "/pay-paye-tax",
          analytics_label_key: "pay_employers_paye",
        },
      ]
      expected_analytics_labels = [
        "HMRC online services: sign in or set up an account",
        "Self Assessment tax returns",
        "Pay employers' PAYE",
      ]
      expect(yielded_links).to eq(expected_links)
      expect(yielded_analytics_labels).to eq(expected_analytics_labels)
      expect(yielded_link_indexes).to eq([1, 2, 3])
      expect(yielded_link_counts).to eq([3, 3, 3])
    end
  end
end
