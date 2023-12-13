RSpec.describe BrowseHelper do
  describe "action links on browse pages" do
    it "returns expected data for a browse page with action links" do
      expected = [
        { text: t("browse.hmrc_online_services"), ga4_text: t("browse.hmrc_online_services", locale: :en), lang: "browse.hmrc_online_services", href: "/log-in-register-hmrc-online-services", index_link: 1, index_total: 3 },
        { text: t("browse.self_assessment_tax_returns"), ga4_text: t("browse.self_assessment_tax_returns", locale: :en), lang: "browse.self_assessment_tax_returns", href: "/self-assessment-tax-returns", index_link: 2, index_total: 3 },
        { text: t("browse.pay_employers_paye"), ga4_text: t("browse.pay_employers_paye", locale: :en), lang: "browse.pay_employers_paye", href: "/pay-paye-tax", index_link: 3, index_total: 3 },
      ]
      expect(helper.action_link_data("business")).to eq(expected)
    end

    it "returns nothing where there are no action links" do
      expect(helper.action_link_data("not-a-page")).to eq([])
    end
  end
end
