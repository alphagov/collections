Before('@mock-email-alert-api') do
  mock_email_alert_api = mock
  Collections.services(:email_alert_api, mock_email_alert_api)
end
