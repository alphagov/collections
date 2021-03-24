RSpec.describe "coronavirus_local_restrictions/results.html" do
  include CoronavirusLocalRestrictionsHelpers

  describe "current restrictions" do
    it "rendering tier 4 results for a postcode in tier 4" do
      render_results_view(local_restriction: { current_alert_level: 4 })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_four.heading_pretext"))
      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_four.heading_tier_label"))
    end

    it "rendering tier 3 results for a postcode in tier 3" do
      render_results_view(local_restriction: { current_alert_level: 3 })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_three.heading_pretext"))
      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_three.heading_tier_label"))
    end

    it "rendering tier 2 results for a postcode in tier 2" do
      render_results_view(local_restriction: { current_alert_level: 2 })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_two.heading_pretext"))
      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_two.heading_tier_label"))
    end

    it "rendering tier 1 results for a postcode in tier 1" do
      render_results_view(local_restriction: { current_alert_level: 1 })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_one.heading_pretext"))
      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_one.heading_tier_label"))
    end
  end

  describe "devolved nations" do
    it "rendering results for a Welsh postcode" do
      render_results_view(local_restriction: { country_name: "Wales" })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.devolved_nations.wales.guidance.label"))
    end

    it "rendering results for a Scottish postcode" do
      render_results_view(local_restriction: { country_name: "Scotland" })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.devolved_nations.scotland.guidance.label"))
    end

    it "rendering results for a Northern Irish postcode" do
      render_results_view(local_restriction: { country_name: "Northern Ireland" })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.devolved_nations.northern_ireland.guidance.label"))
    end
  end

  describe "future restrictions" do
    before { @area = "Naboo" }

    it "rendering restrictions changing from level one to level two" do
      render_results_view(local_restriction: { current_alert_level: 1, future_alert_level: 2, name: @area })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_one.changing_alert_level", area: @area))
      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.future.level_two.alert_level", area: @area))
    end

    it "rendering restrictions changing from level two to level three" do
      render_results_view(local_restriction: { current_alert_level: 2, future_alert_level: 3, name: @area })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_two.changing_alert_level", area: @area))
      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.future.level_three.alert_level", area: @area))
    end

    it "rendering restrictions changing from level three to level four" do
      render_results_view(local_restriction: { current_alert_level: 3, future_alert_level: 4, name: @area })

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.level_three.changing_alert_level", area: @area))
      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.results.future.level_four.alert_level", area: @area))
    end
  end

  describe "out of date restrictions" do
    it "rendering an out of date warning on the tier one page" do
      render_results_view(local_restriction: { current_alert_level: 1 }, out_of_date: true)

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.out_of_date_warning"))
    end

    it "rendering an out of date warning on the tier two page" do
      render_results_view(local_restriction: { current_alert_level: 2 }, out_of_date: true)

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.out_of_date_warning"))
    end

    it "rendering an out of date warning on the tier three page" do
      render_results_view(local_restriction: { current_alert_level: 3 }, out_of_date: true)

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.out_of_date_warning"))
    end

    it "rendering an out of date warning on the tier four page" do
      render_results_view(local_restriction: { current_alert_level: 4 }, out_of_date: true)

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.out_of_date_warning"))
    end
  end

  def render_results_view(local_restriction: {}, out_of_date: false)
    local_restriction = { postcode: "E1 8QS" }.merge(local_restriction)
    @search = PostcodeLocalRestrictionSearch.new(local_restriction[:postcode])
    stub_local_restriction(**local_restriction)
    allow(view)
    .to receive(:out_of_date?)
    .and_return(out_of_date)

    render template: "coronavirus_local_restrictions/results"
  end
end
