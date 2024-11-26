module GovukChatPromoHelper
  GOVUK_CHAT_PROMO_BASE_PATHS = %w[
    /browse/benefits/looking-for-work
    /browse/business
    /browse/business/business-tax
    /browse/business/limited-company
    /browse/business/setting-up
    /browse/employing-people
    /browse/employing-people/payroll
    /browse/employing-people/recruiting-hiring
    /browse/tax
    /browse/tax/capital-gains
    /browse/tax/dealing-with-hmrc
    /browse/tax/self-assessment
    /browse/tax/vat
    /browse/working
    /browse/working/finding-job
    /browse/working/state-pension
    /browse/working/time-off
    /browse/working/workplace-personal-pensions
    /set-up-as-sole-trader
    /set-up-limited-company
  ].freeze

  def show_govuk_chat_promo?(base_path)
    ENV["GOVUK_CHAT_PROMO_ENABLED"] == "true" && GOVUK_CHAT_PROMO_BASE_PATHS.include?(base_path)
  end
end
