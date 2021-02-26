# frozen_string_literal: true

module AccountConcern
  extend ActiveSupport::Concern

  ACCOUNT_SESSION_REQUEST_HEADER_NAME = "HTTP_GOVUK_ACCOUNT_SESSION"
  ACCOUNT_SESSION_RESPONSE_HEADER_NAME = "GOVUK-Account-Session"
  ACCOUNT_SESSION_DEV_COOKIE_NAME = "govuk_account_session"

  included do
    before_action :set_account_variant
  end

  def account_session_header
    if request.headers[ACCOUNT_SESSION_REQUEST_HEADER_NAME]
      request.headers[ACCOUNT_SESSION_REQUEST_HEADER_NAME]
    elsif Rails.env.development?
      cookies[ACCOUNT_SESSION_DEV_COOKIE_NAME]
    end
  end

  def show_signed_in_header?
    account_session_header.present?
  end

  def set_account_variant
    return unless Rails.configuration.feature_flag_govuk_accounts

    response.headers["Vary"] = [response.headers["Vary"], ACCOUNT_SESSION_RESPONSE_HEADER_NAME].compact.join(", ")

    set_slimmer_headers(
      remove_search: true,
      show_accounts: show_signed_in_header? ? "signed-in" : "signed-out",
    )
  end
end
