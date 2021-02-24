module AccountAbTestable
  extend ActiveSupport::Concern

  ACCOUNT_AB_CUSTOM_DIMENSION = 42
  ACCOUNT_AB_TEST_NAME = "AccountExperiment".freeze

  included do
    helper_method :account_variant
    before_action :set_account_variant
  end

  def account_variant
    @account_variant ||= begin
      ab_test = GovukAbTesting::AbTest.new(
        ACCOUNT_AB_TEST_NAME,
        dimension: ACCOUNT_AB_CUSTOM_DIMENSION,
        allowed_variants: %w[LoggedIn LoggedOut],
        control_variant: "LoggedOut",
      )
      ab_test.requested_variant(request.headers)
    end
  end

  def show_signed_in_header?
    account_variant.variant?("LoggedIn")
  end

  def show_signed_out_header?
    account_variant.variant?("LoggedOut")
  end

  def set_account_variant
    return unless Rails.configuration.feature_flag_govuk_accounts
    return unless show_signed_in_header? || show_signed_out_header?

    account_variant.configure_response(response)

    set_slimmer_headers(
      remove_search: true,
      show_accounts: show_signed_in_header? ? "signed-in" : "signed-out",
    )
  end
end
