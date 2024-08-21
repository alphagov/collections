RSpec.describe GovukChatPromoHelper do
  describe "#show_govuk_chat_promo?" do
    it "should return false if the environment variable is not set" do
      ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "false" do
        expect(helper.show_govuk_chat_promo?(described_class::GOVUK_CHAT_PROMO_BASE_PATHS.first)).to be false
      end
    end

    it "should return false if the base path is not in the configured list" do
      ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
        expect(helper.show_govuk_chat_promo?("/does-not-match")).to be false
      end
    end

    it "should return true if the base path is in the configured list" do
      ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
        expect(helper.show_govuk_chat_promo?(described_class::GOVUK_CHAT_PROMO_BASE_PATHS.first)).to be true
      end
    end
  end
end
