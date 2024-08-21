module GovukChatPromoHelper
  GOVUK_CHAT_PROMO_BASE_PATHS = %w[
    /browse/business
    /browse/business/business-tax
    /browse/business/setting-up
    /browse/tax/self-assessment
    /set-up-limited-company
    /set-up-as-sole-trader
  ].freeze

  def show_govuk_chat_promo?(base_path)
    ENV["GOVUK_CHAT_PROMO_ENABLED"] == "true" && GOVUK_CHAT_PROMO_BASE_PATHS.include?(base_path)
  end
end
