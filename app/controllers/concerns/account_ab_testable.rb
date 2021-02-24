# frozen_string_literal: true

module AccountAbTestable
  extend ActiveSupport::Concern

  ACCOUNT_AB_CUSTOM_DIMENSION = 42
  ACCOUNT_AB_TEST_NAME = "AccountExperiment"

  ACCOUNT_SESSION_REQUEST_HEADER_NAME = "HTTP_GOVUK_ACCOUNT_SESSION"
  ACCOUNT_SESSION_RESPONSE_HEADER_NAME = "GOVUK-Account-Session"
  ACCOUNT_SESSION_DEV_COOKIE_NAME = "govuk_account_session"

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

  def account_session_header
    if request.headers[ACCOUNT_SESSION_REQUEST_HEADER_NAME]
      request.headers[ACCOUNT_SESSION_REQUEST_HEADER_NAME]
    elsif Rails.env.development?
      cookies[ACCOUNT_SESSION_DEV_COOKIE_NAME]
    end
  end

  def show_signed_in_header?
    account_session_header.present? || account_variant.variant?("LoggedIn")
  end

  def set_account_variant
    return unless Rails.configuration.feature_flag_govuk_accounts

    account_variant.configure_response(response)
    response.headers["Vary"] = [response.headers["Vary"], ACCOUNT_SESSION_RESPONSE_HEADER_NAME].compact.join(", ")

    set_slimmer_headers(
      remove_search: true,
      show_accounts: show_signed_in_header? ? "signed-in" : "signed-out",
    )
  end
end
